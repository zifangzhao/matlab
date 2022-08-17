function SL_comp=SL_LFP_twosided(rawdata_valid,system_fs,starts,ends,chans,LP,HS,n_rec,p_ref,stps,delays,fname,n_level)
% revised by zifang zhao @ 2012-12-20 ��������level,��������ɸ����ƽ(abs)
% revised by zifang zhao @ 2012-12-12 ������ȡfail��fail�ļ��������ڵ�����
% revised by zifang zhao @ 2012-12-9 �����ļ������룬��temp�ļ���Ӧ����������ļ�(temp_fail�ṹ)
% revised by zifang zhao @ 2012-12-6 �Ż�����ṹ��ȥ��channels��cell�ṹ
% revised by zifang zhao @ 2012-12-5 ����ʱ�ƣ�����ʱ���������
% revised by zifang zhao @ 2012-10-31 ���������������ߣ���0��ʼ
% revised by zifang zhao @ 2012-9-5 ����stp_len��ʱ���жϴ�����length()��Ϊmax()��
% revised by Zifangzhao @ 2012-6-19 ����fs��SL�ṹ����
% created by ZifangZhao @ 2012-6-7


%% �����任
sampling_delay=floor(system_fs./HS/3);% L
embedding=floor(3*HS./LP)+1;% m
w1=sampling_delay.*(embedding-1);
w2=ceil((n_rec/p_ref+2*w1-1)/2);

%% ��ʼ��
stp_range=max(stps+1);
delay_range=max(delays+1);
channels_len =  length(chans);
trim_offset=-ceil(w2);
trim_len=ceil(stp_range+2*w2+delay_range);
% channels     =  zeros(channels_len,2*trim_len);

%% noise ejection
[starts ends]=noise_eject(rawdata_valid,system_fs,starts+trim_offset/1000,ends+trim_offset/1000,trim_len,n_level); %˫���ף�startӦ��-trim_len/2��ʼ
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
trial_temp_file=dir([fname '_fail.mat']);   %�������֮ǰ��fail�ļ��������
time_ind_back=0;


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
        idx_start=round(starts_temp.*system_fs)+trim_offset;   %��ȥһ��w2��Ϊ��ʼ��
        idx_end=round(ends_temp.*system_fs)+trim_offset;
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
        
        if data_len-idx_start>=trim_len  %�жϴ���ʼ�����ݽ����Ƿ���ڼ��㳤��
            channels=zeros(length(chans),trim_len);
            for i = 1:length(chans)
                channels(i,:)=rawdata_filtered{i}(idx_start:idx_start+trim_len-1);
            end
%             clear('rawdata_filtered')
            for m = 1:channels_len
                for n = 1:channels_len
                    cnt=cnt+1;
                    fprintf([ 'Processing:' num2str(cnt) '/' num2str(channels_len^2) '    Processing channels ' num2str(m) ' and ' num2str(n)]);
                    
                    t0=toc;
                    SL{trial}{m,n}=SL_single_twosided(channels(m,:),channels(n,:),w1,w2,embedding,sampling_delay,p_ref,stps,delays);
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
SL_comp.delay=(delays)*1000./system_fs;
SL_comp.startpoint=(stps)*1000./system_fs;
SL_comp.freq=[LP HS];
SL_comp.w1=w1;
SL_comp.w2=w2;
SL_comp.embedding=embedding;
SL_comp.sampling_delay=sampling_delay;
SL_comp.p_ref=p_ref;
SL_comp.fs=system_fs;
end

function data_filtered=fir_filter(rawdata,LP,HP,fs)
if size(rawdata,2)==1
    rawdata=rawdata';
end
N=size(rawdata,2);
band_width=HP-LP;
LS=LP-0.1*band_width;
HS=HP+0.1*band_width;
Dstop1 = 0.001;           % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.0001;          % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([LS LP HP HS]/(fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);
% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

data_filtered=filter(Hd,rawdata);
end

function data_filtered=fft_filter(rawdata,LP,HS,fs)
if size(rawdata,2)==1
    rawdata=rawdata';
end
N=size(rawdata,2);
LP_d=floor(LP*N/fs)+1;
HS_d=round(HS*N/fs);
BP_d=zeros(size(rawdata));
BP_d(:,LP_d:HS_d)=1;
Y=fft(rawdata,N,2);  %�õ�ԭ�źŵ�Ƶ�����
data_filtered=2*real(ifft(Y.*BP_d));
end