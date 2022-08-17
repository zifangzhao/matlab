function SL_comp=SL_LFP_gpu(rawdata_valid,system_fs,starts,ends,chans,LP,HS,n_rec,p_ref,stps,delays,fname,n_level)
% revised by zifang zhao @ 2012-12-20 ��������level,��������ɸ����ƽ(abs)
% revised by zifang zhao @ 2012-12-12 ������ȡfail��fail�ļ��������ڵ�����
% revised by zifang zhao @ 2012-12-9 �����ļ������룬��temp�ļ���Ӧ����������ļ�(temp_fail�ṹ)
% revised by zifang zhao @ 2012-12-6 �Ż�����ṹ��ȥ��channels��cell�ṹ
% revised by zifang zhao @ 2012-12-5 ����ʱ�ƣ�����ʱ���������
% revised by zifang zhao @ 2012-9-12
% �޸��˼���ʱ�����ݳ��ȵ����ƣ�ȡ����trial�ĳ��ȣ���ֻ������ʼʱ��Ͳ������м���
% revised by zifang zhao @ 2012-9-10 ʹ���µ�SL_single_k_v4
% revised by zifang zhao @ 2012-9-9 �������ĺ���Ϊ9-9�°�SL_single_k_v3
% revised by zifang zhao @ 2012-9-5 ����stp_len��ʱ���жϴ�����length()��Ϊmax()��
% revised by Zifangzhao @ 2012-6-19 ����fs��SL�ṹ����
% created by ZifangZhao @ 2012-6-7


%% �����任
sampling_delay=max(floor(system_fs./HS/3),1);% L
embedding=max(floor(3*HS./LP)+1,1);% m
w1=max(sampling_delay.*(embedding-1),1);% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C11`25�е�w1��һ��
w2=ceil(n_rec/p_ref)+w1-1;% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C1125�е�w2��һ��

k=parallel.gpu.CUDAKernel('cal_dist_2.ptx','cal_dist_2.cu');%�����˺���
% k.ThreadBlockSize=[1024 1 1];
% k.GridSize=[64 1];

%% ��ʼ��

stp_range=max(stps+1);
delay_range=max(delays+1);
channels_len =  length(chans);
trim_len=stp_range+w2+(embedding-1)*sampling_delay+delay_range;
channels     =  zeros(channels_len,trim_len);

%%noise ejection
[starts ends]=noise_eject(rawdata_valid,system_fs,starts,ends,trim_len,n_level);
trials       =  length(starts);
SL           =  cell(trials,1);

%% �˲�
rawdata_filtered=cellfun(@(x) fft_filter(x,LP,HS,system_fs),rawdata_valid,'UniformOutput',0);
clear('rawdata_valid');
%% check and start ticking
try
    toc;
catch err
    disp(['There is an Error, Cupcake! ' err.message]);
    tic;
end
multiWaitbar('Trial:',0,'color',[0.5,0.6,0.7]);

%% Data processing
time_ind_back=0;

trial_temp_file=dir([fname '_fail.mat']);   %�������֮ǰ��fail�ļ��������
for trial = 1:trials;
    if ~isempty(trial_temp_file)
        try
            load(trial_temp_file(1).name);
            system(['del ' trial_temp_file(1).name(1:end-8) 'temp.mat']); %��ȡ��ϣ�ɾ��ԭ�ȵ�temp
            system(['rename ' trial_temp_file(1).name ' ' trial_temp_file(1).name(1:end-8) 'temp.mat']); %��fail��Ϊtemp
        catch err
            system(['del ' trial_temp_file(1).name]); %���temp�ļ�������ɾ��֮
        end
    end
    if trial>time_ind_back
        fprintf(2,['Trial ' num2str(trial) ' in processing \n']);
        starts_temp=starts(trial);
        ends_temp=ends(trial);
        idx_start=round(starts_temp.*system_fs);
        idx_end=round(ends_temp.*system_fs);
        data_len=length(rawdata_filtered{1});
        if idx_start==0;
            idx_start=1;
        end
        if idx_end==0;
            idx_end=1;
        end
        if idx_start>data_len
            idx_start=data_len;
        end
        if idx_end>data_len
            idx_end=data_len;
        end
        [ch1 ch2]=meshgrid(1:channels_len,1:channels_len);
        SL{trial}=arrayfun(@(x,y) zeros(length(delays),length(stps)),ch1,ch2,'UniformOutput',0);
        %         SL{trial} = cell(channels_len);
        cnt=0;
        
%         if idx_end-idx_start>=stp_range+w2+(embedding-1)*sampling_delay
        if idx_end-idx_start>=trim_len
            channels=zeros(length(chans),trim_len+1);
            for i = 1:length(chans)
                channels(i,:)=rawdata_filtered{i}(idx_start:idx_start+trim_len);
            end
%             clear('rawdata_filtered')
            for m = 1:channels_len
                for n = 1:channels_len
                    cnt=cnt+1;
                    fprintf([ 'Processing:' num2str(cnt) '/' num2str(channels_len^2) '    Processing channels ' num2str(m) ' and ' num2str(n)]);
                    
                    t0=toc;
                    SL{trial}{m,n}=SL_single_gpu_k_v5(channels(m,:),channels(n,:),w1,w2,embedding,sampling_delay,p_ref,stps,delays,k);
                    t1=toc-t0;
                    
                    fprintf(2,[' time used ' num2str(t1) ' seconds \n']);
                end
            end
        end
        time_ind_back=trial;
        cwd=pwd;
        cd('C:\')
        save([fname '_temp'],'SL','time_ind_back');
        system(['copy c:\' fname '_temp.mat "' cwd '"']);
        system(['del c:\' fname '_temp.mat']);
        cd(cwd);
    end
    multiWaitbar('Trial:',trial/trials,'color',[0.5,0.6,0.7]);
end
delete([fname '_temp.mat'])
SL_comp.data.SL=SL;
SL_comp.delay=(delays)*1000./system_fs+1;
SL_comp.startpoint=(stps)*1000./system_fs+1;
SL_comp.freq=[LP HS];
SL_comp.w1=w1;
SL_comp.w2=w2;
SL_comp.embedding=embedding;
SL_comp.sampling_delay=sampling_delay;
SL_comp.p_ref=p_ref;
SL_comp.fs=system_fs;

k.delete;
end
