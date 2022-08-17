function SL=SL_single(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays)
% revised by zifang zhao @ 2012-12-22 #Fatal#重大修正，修正SL值可能大于一的现象
% revised by zifang zhao @ 2012-12 修正步进不为1时导致的delay矩阵大小错误问题
% revised by zifang zhao @ 2012-9-5 修正stp_len的时间判断错误（由length()改为max()）
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
SL=nan(delay_len,stp_len);

stps=stps+1;
delays=delays+1;

parfor dly_idx=1:length(delays)
    delay=delays(dly_idx);
    data_trim_len=w2+max(stps)+(embedding-1)*sampling_delay ;
%     data_trim_len=length(dataA)-delay_len;
    dataA_cal=dataA(1:data_trim_len+1);   %对B进行延时
    dataB_cal=dataB(delay:delay+data_trim_len);
    data_len=size(dataA_cal,2);
    if data_len>w2+max(stps)+(embedding-1)*sampling_delay %判断数据长度是否小于可计算的最小长度
        %% 生成向量矩阵
        vecA=zeros(embedding,max(stps)+w2);
        vecB=zeros(embedding,max(stps)+w2);
        
        for ebd=1:embedding %根据向量维度生成不同时移的矩阵，再进行拼合
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+max(stps));
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+max(stps));
        end
        
        %% 计算每一组向量和参考向量间的距离
%       vref_range=[1+w2:step:cal_len-w2]; %参考向量的计算区间
        vref_range=stps;    %参考向量的计算区间
%         vec_num=(w2-w1+1); %向量的比较区间
        
%         vec_R_A=zeros(length(vref_range),vec_num); %初始化距离矩阵
%         vec_R_B=zeros(length(vref_range),vec_num);
        
        vec_temp_A=cell(1,length(vref_range));
        vec_temp_B=cell(1,length(vref_range));
        
        for ref_idx=1:length(vref_range)
            ref_tim=vref_range(ref_idx);
            %         tim=[ref_tim-w2:ref_tim-w1,ref_tim+w1:ref_tim+w2];  %双侧计算
            tim=ref_tim+w1:ref_tim+w2; %单侧计算
            vec_temp_A{1,ref_idx}=[vecA(:,ref_tim)'; (vecA(:,tim))'];
            vec_temp_B{1,ref_idx}=[vecB(:,ref_tim)'; (vecB(:,tim))'];
        end
        
        vec_R_temp_A=(cellfun(@cal_vec_dist,vec_temp_A,'UniformOutput',0));
        vec_R_temp_B=(cellfun(@cal_vec_dist,vec_temp_B,'UniformOutput',0));
        
%         for ref_idx=1:length(vref_range)
%             vec_R_A(ref_idx,:)=vec_R_temp_A{1,ref_idx};
%             vec_R_B(ref_idx,:)=vec_R_temp_B{1,ref_idx};
%         end
        
        %% 根据p_ref计算关键距离
        
        vec_R_maxA=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_A,'UniformOutput',0);%找出每一组向量到参考向量的距离中的p_ref位置的距离
        vec_R_maxB=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_B,'UniformOutput',0);
        
        %% 根据事件的同步性计算SL
        synA=cellfun(@(x,r) x<=r,vec_R_temp_A,vec_R_maxA,'UniformOutput',0);
        synB=cellfun(@(x,r) x<=r,vec_R_temp_B,vec_R_maxB,'UniformOutput',0);
        
        SL(dly_idx,:)=cell2mat(cellfun(@(A,B) 2*sum(A&B,2)./(sum(A,2)+sum(B,2)),synA,synB,'UniformOutput',0));
    end
end
end


function vec_dist=cal_vec_dist(vecs) %calculate vector euclidean distance from the first row,there's m * n input and m-1 outputs
Ref=vecs(1,:);
len=size(vecs,1)-1;
if len>0
    Vec=vecs(2:end,:);
    vec_dist=pdist2(Ref,Vec);
else
    vec_dist=nan;
end
end