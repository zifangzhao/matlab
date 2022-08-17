function SL=SL_single_gpu_k_v5(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k)
% revised by zifang zhao @ 2012-12-22 #Fatal#重大修正，修正SL值可能大于一的现象
% revised by zifang zhao @ 2012-12 修正步进不为1时导致的delay矩阵大小错误问题
% revised by zifang zhao @ 2012-9-10 改善了核函数的数组寻址，加速20%
% revised by zifang zhao @ 2012-9-9 使用了新的核函数，加速20倍
% revised by zifang zhao @ 2012-9-5
% 修正stp_len的时间判断错误（由length()改为max()）,以及若干小错误（在默认参数下没问题）
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

stps=stps+1;
delays=delays+1;

vec_num=(w2-w1+1); %向量的比较区间
delay_len=length(delays);
stp_len=length(stps);
SL=nan(delay_len,stp_len);

k.ThreadBlockSize=[vec_num,1,1];
k.GridSize=[1,stp_len];
stp_max=max(stps);
for dly_idx=1:length(delays)
    delay=delays(dly_idx);
    data_trim_len=w2+stp_max+(embedding-1)*sampling_delay+1;
%     data_trim_len=length(dataA)-delay_len;
    dataA_cal=dataA(1:data_trim_len+1);   %对B进行延时
    dataB_cal=dataB(delay:delay+data_trim_len);
    data_len=size(dataA_cal,2);
    if data_len>w2+stp_max+(embedding-1)*sampling_delay %判断数据长度是否小于可计算的最小长度
        %% 生成向量矩阵
        vecA=zeros(embedding,stp_max+w2);
        vecB=zeros(embedding,stp_max+w2);
        
        for ebd=1:embedding %根据向量维度生成不同时移的矩阵，再进行拼合
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_max);
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_max);
        end
        
        %% 计算每一组向量和参考向量间的距离
%       vref_range=[1+w2:step:cal_len-w2]; %参考向量的计算区间
%         vref_range=stps;    %参考向量的计算区间
        
        
        
        distA=zeros(stp_len,vec_num);
        distB=zeros(stp_len,vec_num);
        distA=feval(k,distA,reshape(vecA,1,[]),int32(stps),int32(w1:w2),int32(embedding));
%         distA=feval(k,distA,reshape(vec_zeroA,1,[]),int32(embedding));
        distA=gather(distA);
%         distB=feval(k,distB,reshape(vec_zeroB,1,[]),int32(embedding));
        distB=feval(k,distB,reshape(vecB,1,[]),int32(stps),int32(w1:w2),int32(embedding));
        distB=gather(distB);
        %% 根据p_ref计算关键距离
        vec_R_maxA=fst_prctile(distA,p_ref*100);
        vec_R_maxB=fst_prctile(distB,p_ref*100);
        
        temp_maxA=repmat(vec_R_maxA,[1 size(distA,2)]);
        temp_maxB=repmat(vec_R_maxB,[1 size(distB,2)]);
        synA_mat=distA<=temp_maxA;
        synB_mat=distB<=temp_maxB;
        SL(dly_idx,:)=2*sum(synA_mat&synB_mat,2)'./(sum(synA_mat,2)+sum(synB_mat,2))';
%         synA=arrayfun(@(x) distA(x,:)<=vec_R_maxA(x),1:stp_len,'UniformOutput',0);
%         synB=arrayfun(@(x) distB(x,:)<=vec_R_maxB(x),1:stp_len,'UniformOutput',0);
        %% 根据事件的同步性计算SL
        
        %%old
%         vec_R_temp_A=(cellfun(@cal_vec_dist,vec_temp_A,'UniformOutput',0));
%         vec_R_temp_B=(cellfun(@cal_vec_dist,vec_temp_B,'UniformOutput',0));
        
%         for ref_idx=1:length(vref_range)
%             vec_R_A(ref_idx,:)=vec_R_temp_A{1,ref_idx};
%             vec_R_B(ref_idx,:)=vec_R_temp_B{1,ref_idx};
%         end
        
        
        %% 根据p_ref计算关键距离
%         vec_R_maxA=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_A,'UniformOutput',0);%找出每一组向量到参考向量的距离中的p_ref位置的距离
%         vec_R_maxB=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_B,'UniformOutput',0);
        
        %% 根据事件的同步性计算SL
%         synA=cellfun(@(x,r) x<=r,vec_R_temp_A,vec_R_maxA,'UniformOutput',0);
%         synB=cellfun(@(x,r) x<=r,vec_R_temp_B,vec_R_maxB,'UniformOutput',0);
        
%         SL(dly,:)=cell2mat(cellfun(@(A,B) mean(A&B)./p_ref,synA,synB,'UniformOutput',0));
    end
end

end

%fast prctile
function num=fst_prctile(data,percentage)
N=size(data,2);
data=sort(data,2);
num=data(:,round(percentage*N/100));
end