% 2D algorithm verification
%data load
% uiopen()
%产生pink噪音
clear all
rep=100;
snr=[1 2 10];
SLx=cell(rep,length(snr));
Xcx=cell(rep,length(snr));
raw=cell(rep,length(snr));
%%
multiWaitbar('Progress',0)
for s_idx=1:length(snr)
    for r_idx=1:rep
        
        fs=1000;
        len=8*fs;
        [~,chA]=phase_noise(len,fs,-40);
        [~,chB]=phase_noise(len,fs,-40);
        chA=abs(chA);
        chB=abs(chB);
        chA=zscore(chA);
        chB=zscore(chB);
        % chA=mapminmax(chA,0,1);
        % chB=mapminmax(chB,0,1);
        fft(chA);
        y=fft(chA);
        x=logspace(0,2,length(y)/2);
        loglog(x,2*abs(y(1:end/2)))
        
        xlabel('Frequency (Hz)')
        ylabel('Power (dB)')
        
        % %通过记录信号产生片段
        % rawdata=elec10;
        % data_seg=rawdata(1601:1650);
        % data_seg=data_seg./(max(data_seg)*0.2);
        
        
        
        HF=30;
        LF=13;
        fs=HF*5;
        
        n_rec=20;
        p_ref=0.1;
        chA=resample(chA,fs,1000);
        chA=hwt(chA,LF,HF,fs);
        chB=resample(chB,fs,1000);
        chB=hwt(chB,LF,HF,fs);
        
        % sampling_delay=max(floor(fs/HF/3),1);% L
        % embedding=max(floor(3*HF./LF)+1,1);% m
        % w1=max(sampling_delay.*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–11`25中的w1的一半
        % w2=ceil(n_rec/p_ref)+w1-1;% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w2的一半
        
        sampling_delay=floor(fs./HF/3);% L
        embedding=floor(3*HF./LF)+1;% m
        w1=sampling_delay.*(embedding-1);
        w2=ceil((n_rec/p_ref+2*w1-1)/2);
        
        
        
        
        inc=1;
        t_range=-100/1000*fs:inc:500/1000*fs;
        delays=round(-200/1000*fs:inc:200/1000*fs);
        stps=t_range-min(t_range)-min(delays);
        
        trim_offset=-ceil(w2)+min(delays)+min(t_range);
        stp_range=max(stps+1);
        delay_range=max(delays+1);
        trim_len=ceil(stp_range+2*w2+delay_range);
        
        %通过sin函数产生片段
        seg_len=200/1000*fs;
        seg_fs=20;  %产生的信号频率为20Hz
        t_start=100/1000*fs;
        onset_time=round(t_start)-trim_offset;
        onset_delay=round(30/1000*fs);
        data_seg=sin(2*pi*(seg_fs/fs)*(1:seg_len))'*snr(s_idx);
        gk=mapminmax(gausskernel(floor(length(data_seg)/2),10)',0,1)';
        data_seg=data_seg.*gk(1:length(data_seg));
        chA(onset_time:length(data_seg)+onset_time-1)=chA(onset_time:onset_time+length(data_seg)-1)+data_seg;
        chB(onset_time+onset_delay:length(data_seg)+onset_time+onset_delay-1)=chB(onset_time+onset_delay:onset_time+onset_delay+length(data_seg)-1)+data_seg;
        data_in=[chA chB]';
        raw{r_idx,s_idx}=data_in;
        % % time-shifting signal generation
        % offset=10000;
        % dly=-500;
        % chA=elec10(offset+1:offset+10000);
        % chB=elec10(offset+dly+1:offset+10000+dly);
        
        
        
        % SL_mul=SL_single_twosided(chA',chB',w1,w2,embedding,sampling_delay,p_ref,stps_fixed,delays_fixed);
%          g=gpuDevice(1);
%         reset(g)
        SL_m=SL_mex(data_in,w1,w2,embedding,sampling_delay,p_ref,stps,delays); %%%THIS METHOD MUST HAVE A DELAY STARTING FROM 0!
        SL_m2=reshape(SL_m,size(data_in,1),size(data_in,1),length(stps),length(delays));
        SL_3=cell(2);
        for A=1:size(data_in,1)
            for B=1:size(data_in,1)
                SL_3{A,B}=squeeze(SL_m2(A,B,:,:))';
            end
        end
        SLx{r_idx,s_idx}=SL_m2;
        Xcx{r_idx,s_idx}=amp_corr(data_in',round(1*fs/seg_fs),stps+ceil(w2),delays);
        multiWaitbar('Progress',r_idx/rep)
    end
    multiWaitbar('Progress SNR',s_idx/length(snr))
end
multiWaitbar('Close all')
%%
M=3;
N=3;
figure(2)
tim=(1000/fs).*((1:length(chA))-1)+trim_offset/fs*1000;
for s_idx=1:length(snr)
    cal_func=@(x) squeeze(median(cat(ndims(x{1})+1,x{:,s_idx}),ndims(x{1})+1));
    
    subplot(M,N,(s_idx-1)*N+1)
    plot(tim,bsxfun(@plus,raw{1,s_idx}',[0,20]));
    ylabel('uV')
    xlabel('ms')
%     axis tight
    ylim([-10 30])
    xlim([-500 1000])
    subplot(M,N,(s_idx-1)*N+2);
    SLs=cal_func(SLx);
    imagesc(t_range*1000/fs,delays*1000/fs,squeeze(SLs(1,2,:,:))'); axis xy;
    subplot(M,N,(s_idx-1)*N+3);
    Xcs=cal_func(Xcx);
    imagesc(t_range*1000/fs,delays*1000/fs,squeeze(Xcs(1,2,:,:))'); axis xy;
end
% figure(4)
% 
% subplot(211);plot(tim,chA);
% ylabel('uV')
% xlabel('ms')
% axis tight
% subplot(212);plot(tim,chB);
% xlabel('ms')
% ylabel('uV')
% axis tight
%% calculate SNR
t_test=zeros(length(snr),2);
for s_idx=1:length(snr)
    t=t_range*1000/fs;
    [~,t_loc]=min(abs(t_range-t_start-seg_len/4)); %in samples
    [~,d_loc]=min(abs(delays-onset_delay));
    cat_func=@(x) cat(ndims(x{1})+1,x{:,s_idx});
    SL_all=cat_func(SLx);
    [~,t_test(s_idx,1)]=ttest2(squeeze(SL_all(1,2,t_loc,d_loc,:)),reshape(SL_all(1,2,:,:,:),1,[]));
    Xc_all=cat_func(Xcx);
    [~,t_test(s_idx,2)]=ttest2(squeeze(Xc_all(1,2,t_loc,d_loc,:)),reshape(Xc_all(1,2,:,:,:),1,[]));
end
t_test
