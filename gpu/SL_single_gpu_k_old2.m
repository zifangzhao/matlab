function SL=SL_single_gpu_k(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays)
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

k=parallel.gpu.CUDAKernel('cal_dist.ptx','cal_dist.cu');%�����˺���
k.ThreadBlockSize=[1024 1 1];
k.GridSize=[64 1];

for dly=delays
    delay=dly;
    data_trim_len=length(dataA)-delay_len;
    dataA_cal=dataA(1:data_trim_len+1);   %��B������ʱ
    dataB_cal=dataB(delay:delay+data_trim_len);
    data_len=size(dataA_cal,2);
    if data_len>w2+stp_len+(embedding-1)*sampling_delay %�ж����ݳ����Ƿ�С�ڿɼ������С����
        %% ������������
        vecA=zeros(embedding,stp_len+w2);
        vecB=zeros(embedding,stp_len+w2);
        
        for ebd=1:embedding %��������ά�����ɲ�ͬʱ�Ƶľ����ٽ���ƴ��
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_len);
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+stp_len);
        end
        
        %% ����ÿһ�������Ͳο�������ľ���
%       vref_range=[1+w2:step:cal_len-w2]; %�ο������ļ�������
        vref_range=stps;    %�ο������ļ�������
        vec_num=(w2-w1+1); %�����ıȽ�����
        
        vec_R_A=zeros(length(vref_range),vec_num); %��ʼ���������
        vec_R_B=zeros(length(vref_range),vec_num);
        
%         vec_temp_A=cell(1,length(vref_range));
%         vec_temp_B=cell(1,length(vref_range));
        vec_zeroA=zeros(stp_len,w2-w1+1,embedding);
        vec_zeroB=zeros(stp_len,w2-w1+1,embedding);
        for ref_idx=1:length(vref_range)
            ref_tim=vref_range(ref_idx);
            %         tim=[ref_tim-w2:ref_tim-w1,ref_tim+w1:ref_tim+w2];  %˫�����
            tim=ref_tim+w1:ref_tim+w2; %�������
            vec_zeroA(ref_idx,:,:)=(vecA(:,tim)-repmat(vecA(:,ref_tim),1,(w2-w1+1)))';
            vec_zeroB(ref_idx,:,:)=(vecB(:,tim)-repmat(vecB(:,ref_tim),1,(w2-w1+1)))';
        end
        distA=zeros(stp_len*(w2-w1+1),1);
        distB=zeros(stp_len*(w2-w1+1),1);
        distA=feval(k,distA,reshape(vec_zeroA,1,[]),int32(embedding));
        distA=reshape(gather(distA),stp_len,(w2-w1+1));
        distB=feval(k,distB,reshape(vec_zeroB,1,[]),int32(embedding));
        distB=reshape(gather(distB),stp_len,(w2-w1+1));
        %% ����p_ref����ؼ�����
        vec_R_maxA=prctile(distA,p_ref*100,2);
        vec_R_maxB=prctile(distB,p_ref*100,2);
        synA=arrayfun(@(x) distA(x,:)<=vec_R_maxA(x),1:stp_len,'UniformOutput',0);
        synB=arrayfun(@(x) distB(x,:)<=vec_R_maxB(x),1:stp_len,'UniformOutput',0);
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
        
        SL(dly,:)=cell2mat(cellfun(@(A,B) mean(A&B)./p_ref,synA,synB,'UniformOutput',0));
    end
end
k.delete;
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