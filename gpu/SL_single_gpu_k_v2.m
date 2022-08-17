function SL=SL_single_gpu_k_v2(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k)
%%created by Zifang Zhao @ 2012-6-7
% k is the kernel function
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
SL=nan(delay_len,stp_len);
vref_range=stps;    %参考向量的计算区间
vec_num=(w2-w1+1); %向量的比较区间
if length(dataA)>delay_len+w2+stp_len+(embedding-1)*sampling_delay-1 %判断数据长度是否小于可计算的最小长度
    vec_zeroA=zeros(delay_len,stp_len,vec_num,embedding);
    vec_zeroB=zeros(delay_len,stp_len,vec_num,embedding);
    for dly=delays
        delay=dly;
        data_trim_len=length(dataA)-delay_len;
        dataA_cal=dataA(1:data_trim_len+1);   %对B进行延时
        dataB_cal=dataB(delay:delay+data_trim_len);
        %         data_len=size(dataA_cal,2);
        
        %% 生成向量矩阵
        vecA=zeros(embedding,stp_len+w2);
        vecB=zeros(embedding,stp_len+w2);
        
        for ebd=1:embedding %根据向量维度生成不同时移的矩阵，再进行拼合
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_len);
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_len);
        end
        
        %% 计算每一组向量和参考向量间的距离
        %       vref_range=[1+w2:step:cal_len-w2]; %参考向量的计算区间
        
        
        
        %         vec_temp_A=cell(1,length(vref_range));
        %         vec_temp_B=cell(1,length(vref_range));
        
        for ref_idx=1:length(vref_range)
            ref_tim=vref_range(ref_idx);
            %         tim=[ref_tim-w2:ref_tim-w1,ref_tim+w1:ref_tim+w2];  %双侧计算
            tim=ref_tim+w1:ref_tim+w2; %单侧计算
            vec_zeroA(dly,ref_idx,:,:)=(vecA(:,tim)-repmat(vecA(:,ref_tim),1,(vec_num)))';
            vec_zeroB(dly,ref_idx,:,:)=(vecB(:,tim)-repmat(vecB(:,ref_tim),1,(vec_num)))';
        end
    end
    
    distA=zeros(delay_len*stp_len*(vec_num),1);
    distB=zeros(delay_len*stp_len*(vec_num),1);
    distA=feval(k,distA,reshape(vec_zeroA,1,[]),int32(embedding));
    distA=reshape(gather(distA),delay_len,stp_len,(vec_num));
    distB=feval(k,distB,reshape(vec_zeroB,1,[]),int32(embedding));
    distB=reshape(gather(distB),delay_len,stp_len,(vec_num));
    %% 根据p_ref计算关键距离
    for dly=delays
        vec_R_maxA=prctile(distA,p_ref*100,2);
        vec_R_maxB=prctile(distB,p_ref*100,2);
        synA=arrayfun(@(x) distA(x,:)<=vec_R_maxA(x),1:stp_len,'UniformOutput',0);
        synB=arrayfun(@(x) distB(x,:)<=vec_R_maxB(x),1:stp_len,'UniformOutput',0);
        
        
        SL(dly,:)=cell2mat(cellfun(@(A,B) mean(A&B)./p_ref,synA,synB,'UniformOutput',0));
    end
end

end

