function STFT_comp=stft(rawdata_valid,system_fs,starts,ends,chans,trim_len,window,noverlap,nfft,fname,n_level)
% created by ZifangZhao @ 2013-2-1 based on SL_multidelay


%% 初始化
channels_len =  length(chans);
% channels     =  zeros(channels_len,2*trim_len);

%% noise ejection
[starts ends]=noise_eject(rawdata_valid,system_fs,starts,ends,trim_len,n_level); %双边谱，start应从-trim_len/2开始
trials       =  length(starts);
STFT         =  cell(trials,1);


%% check and start ticking
try
    toc;
catch err
    disp(['There is an Error, Cupcake! ' err.message]);
    tic;
end
multiWaitbar('Trial:',0,'color',[0.5,0.6,0.7]);

%% Data processing
trial_temp_file=dir([fname '_fail.mat']);   %如果存在之前的fail文件，则继续
time_ind_back=0;


for trial = 1:trials;
    if ~isempty(trial_temp_file)
        try
            load(trial_temp_file(1).name);
            system(['del ' trial_temp_file(1).name(1:end-8) 'temp.mat']); %读取完毕，删除原先的temp
            system(['rename ' trial_temp_file(1).name ' ' trial_temp_file(1).name(1:end-8) 'temp.mat']); %将fail改为temp

        catch err
            system(['del ' trial_temp_file(1).name]); %如果temp文件出错则删除之
        end
    end
    if trial>time_ind_back
        fprintf(2,['Trial ' num2str(trial) ' in processing \n']);
        starts_temp=starts(trial);
        ends_temp=ends(trial);
        idx_start=round(starts_temp.*system_fs);   %
        idx_end=round(ends_temp.*system_fs);
        data_len=length(rawdata_valid{1});
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
%         [ch1 ch2]=meshgrid(1:channels_len,1:channels_len);
%        STFT{trial}=arrayfun(@(x,y) zeros(length(delays),length(stps)),1:channels_len,'UniformOutput',0);
     
%         SL{trial} = cell(channels_len);
        cnt=0;
        
        if data_len-idx_start>=trim_len  %判断从起始到数据结束是否大于计算长度
            channels=zeros(length(chans),trim_len);
            for i = 1:length(chans)
                channels(i,:)=rawdata_valid{i}(idx_start:idx_start+trim_len-1);
            end
%             clear('rawdata_filtered')
            temp=cell(channels_len,1);
            parfor m = 1:channels_len
                
%                     cnt=cnt+1;
%                     fprintf([ 'Processing:' num2str(cnt) '/' num2str(channels_len^2) '    Processing channels ' num2str(m) ' and ' num2str(n)]);
                    
%                     t0=toc;
                    [S,F,T,P]=spectrogram(channels(m,:),window,noverlap,nfft,system_fs);
                    temp{m}.S=S;
                    temp{m}.F=F;
                    temp{m}.T=T;
                    temp{m}.P=P;
                    temp{m}.waveform_pre=channels(m,1:trim_len/2);
                    temp{m}.waveform_post=channels(m,trim_len/2+1:end);
%                     temp{m}.fft=fft(channels(m,:));
%                     t1=toc-t0;
                    
%                     fprintf(2,[' time used ' num2str(t1) ' seconds \n']);

            end
            STFT{trial}=temp;
        end
        time_ind_back=trial;
                cwd=pwd;
        cd('C:\')  ;
        save([fname '_temp' ],'STFT','time_ind_back');
        system(['copy c:\' fname '_temp.mat "' cwd '"']);
        system(['del c:\' fname '_temp.mat']);
        cd(cwd);
    end
    multiWaitbar('Trial:',trial/trials,'color',[0.5,0.6,0.7]);
end
delete([fname '_temp.mat'])
STFT_comp.data.STFT=STFT;
STFT_comp.fs=system_fs;
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
Y=fft(rawdata,N,2);  %得到原信号的频域表征
data_filtered=2*real(ifft(Y.*BP_d));
end