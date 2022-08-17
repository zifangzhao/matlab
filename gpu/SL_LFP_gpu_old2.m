function SL_comp=SL_LFP(rawdata_valid,system_fs,starts,ends,chans,LP,HS,n_rec,p_ref,stps,delays)
% revised by Zifangzhao @ 2012-6-19 增加fs到SL结构体中
% created by ZifangZhao @ 2012-6-7

%% 初始化
trials       =  length(starts);
SL           =  cell(trials,1);

channels     =  cell(1,length(chans));
channels_len =  length(chans);
%% 参数变换
sampling_delay=max(floor(system_fs./HS/3),1);% L
embedding=max(floor(3*HS./LP)+1,1);% m
w1=max(sampling_delay.*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–11`25中的w1的一半
w2=ceil(n_rec/p_ref)+w1-1;% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w2的一半


%% 滤波
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
for trial = 1:trials;
    trial_temp_file=dir('temp_sl.mat');
    if ~isempty(trial_temp_file)&&trial==1
        load(trial_temp_file.name);
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
        SL{trial} = cell(channels_len);
        cnt=0;
        stp_len=length(stps);
        delay_len=length(delays);
        if idx_end-idx_start>=stp_len+w2+(embedding-1)*sampling_delay
            parfor i = 1:length(chans)
                channels{i}=rawdata_filtered{i}(idx_start:idx_start+stp_len+delay_len+w2+(embedding-1)*sampling_delay);
            end
%             clear('rawdata_filtered')
            for m = 1:channels_len
                for n = 1:channels_len
                    cnt=cnt+1;
                    fprintf([ 'Processing:' num2str(cnt) '/' num2str(channels_len^2) '    Processing channels ' num2str(m) ' and ' num2str(n)]);
                    
                    t0=toc;
                    SL{trial}{m,n}=SL_single_gpu_k(channels{m},channels{n},w1,w2,embedding,sampling_delay,p_ref,stps,delays);
                    t1=toc-t0;
                    
                    fprintf(2,[' time used ' num2str(t1) ' seconds \n']);
                end
            end
        end
        time_ind_back=trial;
        save('temp_sl','SL','time_ind_back');
    end
    multiWaitbar('Trial:',trial/trials,'color',[0.5,0.6,0.7]);
end
delete('temp_sl.mat')
SL_comp.data.SL=SL;
SL_comp.delay=(0:delay_len-1)*1000./system_fs;
SL_comp.startpoint=(w1:w1+stp_len-1)*1000./system_fs;
SL_comp.freq=[LP HS];
SL_comp.w1=w1;
SL_comp.w2=w2;
SL_comp.embedding=embedding;
SL_comp.sampling_delay=sampling_delay;
SL_comp.p_ref=p_ref;
SL_comp.fs=system_fs;
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
Y=fft(rawdata,N,2);  %得到原信号的频域表征
data_filtered=2*real(ifft(Y.*BP_d));
end