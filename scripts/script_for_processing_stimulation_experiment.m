%%script for analysis HD32 stimulation data

%% created by zifang zhao 2014/10/15

%%Main function of this script would be
%Data loading
%stimulation detection (wavelet extract phase)
%spike time vs stimulation phase
%LFP power vs stimulation phase

%% parameters setting
Nchan=10;
chans=1:10;
% chans=[4:8 36:40];
fs_LFP=1.25e3;
fs_raw=20e3;
time_to_load=9300;
hist_bins=120;
%% Data_loading

%load lfp file
f=dir('*.lfp');
file_lfp=f(1).name;
LFP=readmulti_frank(file_lfp,Nchan,chans,0,fs_LFP*time_to_load);

%% extract stimulation
% LFP_1Hz=fft_filter(LFP',0.9,1.1,fs);

%% stimulation detection
%select channels have large difference between stimulation and recording
LFP_median=readmulti_frank('amplifier_med.dat',1,1,0,fs_raw*time_to_load);
LFP_median=resample(LFP_median,fs_LFP,fs_raw);
% LFP_std=std(LFP,[],1);
% stim_idx=find(LFP_std>3000);
LFP_wt=zeros(size(LFP));
for idx=1:size(LFP,2)
    LFP_wt(:,idx)=awt_freqlist(LFP(:,idx),fs_LFP,1,'Gabor');   %get the instaneously power of stimulation
end
LFP_1Hz_mean=mean(abs(LFP_wt),2);
Detect_th=500;
%Detect_th=prctile(LFP_1Hz_mean,60);  %threshold for stimulation detection based on percentage
figure(1);
hold off;
plot(LFP_1Hz_mean);
hold on;
plot([0 length(LFP_1Hz_mean)],[ Detect_th Detect_th],'r');

stimu_time=LFP_1Hz_mean>Detect_th;

%% fix the detection error
t_min=15; %min time in second
temp=[diff([0 stimu_time(1:end-1)' 0])];

starts=find(temp==1);
ends=find(temp==-1);
for idx=1:length(starts)
    if ends(idx)-starts(idx)<t_min*fs_LFP
        stimu_time(starts(idx):ends(idx))=0;
    end
end
plot(stimu_time*6000,'r');

%% phase extraction
stimu_phase=angle(mean(LFP_wt,2));
clear('LFP_wt');
%% spike file loading
file_spk=dir('*.fet.*');
t_spike=cell(length(file_spk),1);
% c_pca=cell(length(file_spk),1);
hist_s_p=cell(length(file_spk),1); %spk vs phase hist

for idx=1:length(file_spk)
    spike_in_wave=zeros(size(LFP,1),1);
%     t_spike{idx}=importdata(file_spk(idx).name);
    name=file_spk(1).name;
    x=strfind(name,'.');
    name=[name(1:x(end)) num2str(idx)];
    [t_spike{idx}, c_pca{idx}]=fet_reader(name);
    temp=round(t_spike{idx}/fs_raw*fs_LFP);
    temp=temp(temp<size(LFP,1));
    spike_in_wave(temp)=1;
    % spike vs stimu phase
    spike_inStimu=spike_in_wave&stimu_time;
    [hist_s_p{idx},x]=hist(stimu_phase(spike_inStimu),hist_bins);
            figure(6)
        subplot(3,4,idx);
        rose(stimu_phase(spike_inStimu));
end
%%
for idx=1:length(file_spk)
    spike_in_wave=zeros(size(LFP,1),1);
    temp=round(t_spike{idx}/fs_raw*fs_LFP);
    temp=temp(temp<size(LFP,1));
    spike_in_wave(temp)=1;
    % spike vs stimu phase
    spike_inStimu=spike_in_wave&stimu_time;
    [hist_s_p{idx},x]=hist(stimu_phase(spike_inStimu),hist_bins);
    %normalize
    hist_s_p{idx}=hist_s_p{idx}./(sum(stimu_time))*fs_LFP*hist_bins;
    figure(6)
    subplot(3,4,idx);
    d=stimu_phase(spike_inStimu);
    h=rose(d,60);
    
    xx=get(h,'Xdata');
    yy=get(h,'Ydata');
    
    h2=patch(xx,yy,[0.5 0.5 1]);
    set(h2,'linestyle','none');
%                 xx=arrayfun(@(x) get(x,'Xdata'),h_r,'Uniformoutput',0);
%             yy = arrayfun(@(x) get(x,'Ydata'),h_r,'Uniformoutput',0);
%             arrayfun(@(x) patch(xx{x},yy{x},hsv2rgb(mod(spk_in_range(x),50)/50,1,1)),idx);
end
%% clustering based on PCA
% idx=3;
% % clu=kmeans(c_pca{idx},10);

%% spike calculation based on FIL file
if 0
    FIL_file=dir('*.FIL');
    start=0;
    win=50;
    % noise_win=20;
    % noise_padding_tmp=zeros(0.5*noise_win*fs_raw,length(chans));
    t_spk_man=cell(length(chans),1);
    if matlabpool('size')==0
        matlabpool
    end
    while start*fs_raw*2*Nchan<FIL_file(1).bytes
        multiWaitbar('Processing spikes:',start*fs_raw*2*Nchan/FIL_file(1).bytes);
        FIL_all=readmulti_frank(FIL_file(1).name,Nchan,chans,fs_raw*start,fs_raw*(start+win));
        FIL_all=FIL_all-median(FIL_all,2)*ones(1,size(FIL_all,2)); %denoise
        noise=3*std(abs(FIL_all),[],1);
        %     noise=prctile(abs(FIL_all),95);
        parfor idx=1:length(chans)
            t_spk_man{idx}=[t_spk_man{idx} ; start*fs_raw+Peak_finder_negative_voltage(FIL_all(:,chans(idx)),700,inf)];
%             t_spk_man{idx}=[t_spk_man{idx} ; start*fs_raw+Peak_finder_negative_voltage(FIL_all(:,idx),noise(idx),inf)];
        end
        start=start+win;
    end
    multiWaitbar('closeall')
    %% hist
    hist_s_m_p=cell(length(chans),1); %spk vs phase hist
    for idx=1:length(chans)
        spike_in_wave=zeros(size(LFP,1),1);
        temp=round(t_spk_man{idx}/fs_raw*fs_LFP);
        temp=temp(temp<size(LFP,1));
        spike_in_wave(temp)=1;
        % spike vs stimu phase
        spike_inStimu=spike_in_wave&stimu_time;
        [hist_s_m_p{idx},x]=hist(stimu_phase(spike_inStimu),hist_bins);
        hist_s_m_p{idx}=hist_s_m_p{idx}./sum(stimu_time)*fs_LFP*hist_bins;
    end
end


%% (optional) plot FIL file and spiking time for selected channel
if 0
    c=3; %channel selection
    FIL_file=dir('*.fil');
    win=5;
    start=00;
   
    while start*fs_raw*2*Nchan<FIL_file(1).bytes & start<time_to_load

        FIL_all=readmulti_frank(FIL_file(1).name,Nchan,chans,fs_raw*start,fs_raw*(start+win));
        FIL=FIL_all(:,chans(c));
%         FIL=fft_filter(FIL_all(:,3),1250,10e3,fs_raw)';
%         FIL_denoise=FIL-median(FIL_all,2);
        % (option) plot
        h=figure(4);
        hold off;
        t=(0:size(FIL,1)-1)/fs_raw+start;
        plot(t,FIL)
        hold on;
%         plot(t,FIL-median(FIL_all,2),'k')
        spk=zeros(size(FIL));
        t_spk=t_spike{c};
        t_spk=round(t_spk((t(1)*fs_raw<t_spk)&(t_spk<t(end)*fs_raw))-t(1)*fs_raw);
        spk(t_spk)=1000;
        plot(t,spk,'r');
        
        stim=resample(double(stimu_time(t(1)*fs_LFP:t(end)*fs_LFP)),fs_raw,fs_LFP);
        
        plot(t,stim*1000,'g')
        
        %run_spk_dection
        spk_man=zeros(size(FIL));
        if exist('t_spk_man')
            t_spk_temp=t_spk_man{c};
            t_spk_temp=round(t_spk_temp((t_spk_temp>t(1)*fs_raw)&(t_spk_temp<t(end)*fs_raw))-t(1)*fs_raw);
            %     t_spk_man=Peak_finder_negative_voltage(FIL_denoise,6*std(abs(FIL_denoise)),inf);
            spk_man(t_spk_temp)=-1000;
            plot(t,spk_man,'y');
        end
        drawnow;
        pause();
        start=start+win;
    end
    
end
%% Hist plot
h=figure(3);
for idx=1:length(chans)
    
    sh=subplot(4,4,idx);
    pt=linspace(-180,3*180,hist_bins*2);
    bar(pt(1:end/2),(hist_s_p{idx}),1,'edgecolor','b','facecolor','b','linestyle','none');
    hold on
    bar(pt(end/2+1:end),(hist_s_p{idx}),1,'edgecolor','b','facecolor','b','linestyle','none');hold off
    hold on;
    y=ylim();
    h=plot([x/2/pi*360 360+x/2/pi*360],(1+cos([x,x+2*pi]))*0.15*y(2),'k','linewidth',2);
    hold off;
    set(gca,'Xtick',[-180:90:540]);
%     set(gca,'XtickLabel',{'-pi','-0.5pi','0','0.5pi','pi','1.5pi','2pi','2.5pi','3pi'});
%     alpha(0.7)
    xlim([-180 180+360])
end
%% plot to testify
figure(2);
hold off;
plot(stimu_phase*max(LFP(stimu_time,1))/5);
hold on;
plot(LFP_1Hz_mean(stimu_time,1),'r')
plot(LFP(stimu_time,1),'g');
bar(spike_in_wave(stimu_time)*30000);


%% plot spiking probabilities (rest/stimu)
t_stimu_cnt=sum(stimu_time)/fs_LFP;
t_rest_cnt=sum(~stimu_time)/fs_LFP;
spk_cnt=zeros(length(file_spk),2);
for idx=1:length(file_spk)
   spike_in_wave=zeros(size(LFP,1),1);
    temp=round(t_spike{idx}/fs_raw*fs_LFP);
    temp=temp(temp<size(LFP,1));
    spike_in_wave(temp)=1;
    % spike vs stimu phase
    spk_cnt(idx,1)=sum(spike_in_wave&~stimu_time)/t_rest_cnt;
    spk_cnt(idx,2)=sum(spike_in_wave&stimu_time)/t_stimu_cnt;
end

figure(4)
bar(spk_cnt,'Grouped');

%% plot rasterplot
temp=diff([0 stimu_time(1:end-1)' 0]);
starts=find(temp==1);
ends=find(temp==-1); clear('temp');
zero_phases_all=[];
for idx=1:length(starts)
    temp=stimu_phase(starts(idx):ends(idx));
    [~,zero_phases]=findpeaks(temp);
    zero_phases=round(zero_phases-0.25*fs_LFP);
    zero_phases(zero_phases<=0 |zero_phases>length(temp))=[];
%     zero_phases=find(temp(temp==0));
    if zero_phases(end)+fs_LFP>length(temp)
        zero_phases(end)=[];
    end
    zero_phases_all=[zero_phases_all ; starts(idx)+zero_phases];
end
% raster_idx=zeros(fs_LFP,size(zero_phases_all,1));
raster_idx=reshape((zero_phases_all*ones(1,fs_LFP)+ones(size(zero_phases_all,1),1)*(1:fs_LFP))',1,[]);
figure(7)
for idx=1:length(file_spk)
    subplot(3,4,idx)
%     rasterPlt=zeros(fs_LFP*size(zero_phases_all,1),1);
    spike_in_wave=zeros(size(LFP,1),1);
    temp=round(t_spike{idx}/fs_raw*fs_LFP);
    temp=temp(temp<size(LFP,1));
    spike_in_wave(temp)=1;
    rasterPlt=logical(reshape(spike_in_wave(raster_idx),fs_LFP,[]));
    LineFormat = struct();
    LineFormat.Color = [0.3 0.3 0.3];
    LineFormat.LineWidth = 0.35;
    LineFormat.LineStyle = ':';
    plotSpikeRaster(rasterPlt','plottype','vertline','TimePerBin',1/fs_LFP,'SpikeDuration',1/fs_LFP,'LineFormat',LineFormat);
end
%% LFP power vs stimu phase

