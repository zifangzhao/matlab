function SL=SL_single_gpu(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays)
%%created by Zifang Zhao @ 2012-6-7
%% 参数设置
if nargin<5
    embedding=3;
end
if nargin<6
    sampling_delay=1;
end
if nargin<7
    p_ref=0.05;
end
delay_len=length(delays);
stp_len=length(stps);
SL=gpuArray(nan(delay_len,stp_len));

data_trim_len=length(dataA)-delay_len;
if data_trim_len+1>=w2+stp_len+(embedding-1)*sampling_delay %判断数据长度是否小于可计算的最小长度
    
    dataA_cal=gpuArray(dataA(1:data_trim_len+1));   %初始化A，将数据存入gpu
    dataB_cal=parallel.gpu.GPUArray.zeros(data_trim_len+1,length(delays));  %初始化dataB gpuarray
    for idx=1:length(delays)
        dly=delays(idx);
        %     tmp = parallel.gpu.GPUArray.colon(dly,dly+data_trim_len);
        dataB_cal(:,idx) = gpuArray(dataB(dly,dly+data_trim_len));
    end
    
    %% 生成向量矩阵
    vecA=parallel.gpu.GPUArray.zeros(embedding,stp_len+w2);
    vecB=parallel.gpu.GPUArray.zeros(embedding,stp_len+w2);
    
    for ebd=parallel.gpu.GPUArray.colon(1,embedding) %根据向量维度生成不同时移的矩阵，再进行拼合
        temp=parallel.gpu.GPUArray.colon(1+(ebd-1)*sampling_delay,(ebd-1)*sampling_delay+w2+stp_len);
        vecA(ebd,:)=dataA_cal(temp);
        vecB(ebd,:)=dataB_cal(temp);
    end
    
    %% 计算每一组向量和参考向量间的距离
    vref_range=stps;    %参考向量的计算区间
    vec_num=(w2-w1+1); %向量的比较区间
    
    synA=parallel.gpu.GPUArray.zeros(length(vref_range),vec_num);
    synB=parallel.gpu.GPUArray.zeros(length(vref_range),vec_num);
    for ref_idx=1:length(vref_range)
        ref_tim=vref_range(ref_idx);
        tim=parallel.gpu.GPUArray.colon(ref_tim+w1,ref_tim+w2); %单侧计算
        tempA=cal_vec_dist([vecA(:,ref_tim)'; (vecA(:,tim))']);
        tempB=cal_vec_dist([vecB(:,ref_tim)'; (vecB(:,tim))']);
        temp_maxA=prctile_gpu(tempA,p_ref*100);%% 根据p_ref计算关键距离
        temp_maxB=prctile_gpu(tempB,p_ref*100);
        synA(ref_idx,:)=tempA<=temp_maxA;%% 计算事件同步性
        synB(ref_idx,:)=tempB<=temp_maxB;
    end
    SL(dly,:)=(mean(synA&synB,2)./p_ref);
end
end

function p_num=prctile_gpu(data,per)
len=length(data);
loc=round(per/100*len);
data=sort(data);
p_num=data(loc);
end

function vec_dist=cal_vec_dist(vecs) %calculate vector euclidean distance from the first row,there's m * n input and m-1 outputs
Ref=vecs(1,:);
len=size(vecs,1);
% vec_dist=vecs(1:end-1);
if len>1
    idx=parallel.gpu.GPUArray.colon(2,len);
    Cpr=vecs(idx,:);
    vec_dist=cell2mat(arrayfun(@(x) norm(Ref-Cpr(x,:),2),(1:len-1),'UniformOutput',0));
    %     vec_dist=arrayfun(@(x) Ref-Cpr(x,:),1:len-1,'UniformOutput',0);
    %     vec_dist=pdist2(Ref,vecs(2:end,:));
else
    vec_dist=nan;
end
end