function SL=SL_single(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays)
% revised by zifang zhao @ 2012-12-22 #Fatal#�ش�����������SLֵ���ܴ���һ������
% revised by zifang zhao @ 2012-12 ����������Ϊ1ʱ���µ�delay�����С��������
% revised by zifang zhao @ 2012-9-5 ����stp_len��ʱ���жϴ�����length()��Ϊmax()��
%%created by Zifang Zhao @ 2012-6-7
%% ��������
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
    dataA_cal=dataA(1:data_trim_len+1);   %��B������ʱ
    dataB_cal=dataB(delay:delay+data_trim_len);
    data_len=size(dataA_cal,2);
    if data_len>w2+max(stps)+(embedding-1)*sampling_delay %�ж����ݳ����Ƿ�С�ڿɼ������С����
        %% ������������
        vecA=zeros(embedding,max(stps)+w2);
        vecB=zeros(embedding,max(stps)+w2);
        
        for ebd=1:embedding %��������ά�����ɲ�ͬʱ�Ƶľ����ٽ���ƴ��
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+max(stps));
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+max(stps));
        end
        
        %% ����ÿһ�������Ͳο�������ľ���
%       vref_range=[1+w2:step:cal_len-w2]; %�ο������ļ�������
        vref_range=stps;    %�ο������ļ�������
%         vec_num=(w2-w1+1); %�����ıȽ�����
        
%         vec_R_A=zeros(length(vref_range),vec_num); %��ʼ���������
%         vec_R_B=zeros(length(vref_range),vec_num);
        
        vec_temp_A=cell(1,length(vref_range));
        vec_temp_B=cell(1,length(vref_range));
        
        for ref_idx=1:length(vref_range)
            ref_tim=vref_range(ref_idx);
            %         tim=[ref_tim-w2:ref_tim-w1,ref_tim+w1:ref_tim+w2];  %˫�����
            tim=ref_tim+w1:ref_tim+w2; %�������
            vec_temp_A{1,ref_idx}=[vecA(:,ref_tim)'; (vecA(:,tim))'];
            vec_temp_B{1,ref_idx}=[vecB(:,ref_tim)'; (vecB(:,tim))'];
        end
        
        vec_R_temp_A=(cellfun(@cal_vec_dist,vec_temp_A,'UniformOutput',0));
        vec_R_temp_B=(cellfun(@cal_vec_dist,vec_temp_B,'UniformOutput',0));
        
%         for ref_idx=1:length(vref_range)
%             vec_R_A(ref_idx,:)=vec_R_temp_A{1,ref_idx};
%             vec_R_B(ref_idx,:)=vec_R_temp_B{1,ref_idx};
%         end
        
        %% ����p_ref����ؼ�����
        
        vec_R_maxA=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_A,'UniformOutput',0);%�ҳ�ÿһ���������ο������ľ����е�p_refλ�õľ���
        vec_R_maxB=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_B,'UniformOutput',0);
        
        %% �����¼���ͬ���Լ���SL
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