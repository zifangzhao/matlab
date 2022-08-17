function SL=SL_single_gpu_k_v5(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k)
% revised by zifang zhao @ 2012-12-22 #Fatal#�ش�����������SLֵ���ܴ���һ������
% revised by zifang zhao @ 2012-12 ����������Ϊ1ʱ���µ�delay�����С��������
% revised by zifang zhao @ 2012-9-10 �����˺˺���������Ѱַ������20%
% revised by zifang zhao @ 2012-9-9 ʹ�����µĺ˺���������20��
% revised by zifang zhao @ 2012-9-5
% ����stp_len��ʱ���жϴ�����length()��Ϊmax()��,�Լ�����С������Ĭ�ϲ�����û���⣩
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

stps=stps+1;
delays=delays+1;

vec_num=(w2-w1+1); %�����ıȽ�����
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
    dataA_cal=dataA(1:data_trim_len+1);   %��B������ʱ
    dataB_cal=dataB(delay:delay+data_trim_len);
    data_len=size(dataA_cal,2);
    if data_len>w2+stp_max+(embedding-1)*sampling_delay %�ж����ݳ����Ƿ�С�ڿɼ������С����
        %% ������������
        vecA=zeros(embedding,stp_max+w2);
        vecB=zeros(embedding,stp_max+w2);
        
        for ebd=1:embedding %��������ά�����ɲ�ͬʱ�Ƶľ����ٽ���ƴ��
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_max);
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_max);
        end
        
        %% ����ÿһ�������Ͳο�������ľ���
%       vref_range=[1+w2:step:cal_len-w2]; %�ο������ļ�������
%         vref_range=stps;    %�ο������ļ�������
        
        
        
        distA=zeros(stp_len,vec_num);
        distB=zeros(stp_len,vec_num);
        distA=feval(k,distA,reshape(vecA,1,[]),int32(stps),int32(w1:w2),int32(embedding));
%         distA=feval(k,distA,reshape(vec_zeroA,1,[]),int32(embedding));
        distA=gather(distA);
%         distB=feval(k,distB,reshape(vec_zeroB,1,[]),int32(embedding));
        distB=feval(k,distB,reshape(vecB,1,[]),int32(stps),int32(w1:w2),int32(embedding));
        distB=gather(distB);
        %% ����p_ref����ؼ�����
        vec_R_maxA=fst_prctile(distA,p_ref*100);
        vec_R_maxB=fst_prctile(distB,p_ref*100);
        
        temp_maxA=repmat(vec_R_maxA,[1 size(distA,2)]);
        temp_maxB=repmat(vec_R_maxB,[1 size(distB,2)]);
        synA_mat=distA<=temp_maxA;
        synB_mat=distB<=temp_maxB;
        SL(dly_idx,:)=2*sum(synA_mat&synB_mat,2)'./(sum(synA_mat,2)+sum(synB_mat,2))';
%         synA=arrayfun(@(x) distA(x,:)<=vec_R_maxA(x),1:stp_len,'UniformOutput',0);
%         synB=arrayfun(@(x) distB(x,:)<=vec_R_maxB(x),1:stp_len,'UniformOutput',0);
        %% �����¼���ͬ���Լ���SL
        
        %%old
%         vec_R_temp_A=(cellfun(@cal_vec_dist,vec_temp_A,'UniformOutput',0));
%         vec_R_temp_B=(cellfun(@cal_vec_dist,vec_temp_B,'UniformOutput',0));
        
%         for ref_idx=1:length(vref_range)
%             vec_R_A(ref_idx,:)=vec_R_temp_A{1,ref_idx};
%             vec_R_B(ref_idx,:)=vec_R_temp_B{1,ref_idx};
%         end
        
        
        %% ����p_ref����ؼ�����
%         vec_R_maxA=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_A,'UniformOutput',0);%�ҳ�ÿһ���������ο������ľ����е�p_refλ�õľ���
%         vec_R_maxB=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_B,'UniformOutput',0);
        
        %% �����¼���ͬ���Լ���SL
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