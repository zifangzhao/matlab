%%HD32BR6 stimulation and recording experiment
%%cal_noise
%% file loading
[fname,pname]=uigetfile('*.dat');
fname=[pname fname];
t=regexpi(fname,'HD32BR(\d)','tokens');
if  str2double(t{1})==5
    Vref=3.3;
else
    Vref=2.42;
end
chnnum=32;
t=regexpi(fname,'_(\d+)K','tokens');
fs_mux=str2double(t{1}{1})*1e3;

swp_time=30; %sweep time in second
swp_freq=[0.1 500];
t_start=600; %in seconds
t_end=3600*7;% in seconds

fs=fs_mux/chnnum;
convert_eff=1/65535*Vref/200*1e6;

channel_list=[22 23];
sel_chn=1;%22;
% gnd_chn=22%23;

data=readmulti_frank(fname,chnnum,channel_list,t_start*fs,t_end*fs)*convert_eff;

%%
data=data-(median(data,1)'*ones(1,size(data,1)))';

offset=([size(data,2):-1:1]'*ones(1,size(data,1)))';
% plot(data+2000*offset);

data_sel=data(:,sel_chn);
data_sel=data_sel-mean(data_sel);

%% Applying Filter
[b,a]=butter(3,0.08/fs,'high');
data_sel=filter(b,a,data_sel);

%% sweep segment extraction

p=awt_freqlist(data_sel,fs,swp_freq(end),'Gabor');  
dp=diff(abs(p));
%find peaks
dpNeg=[0 ;-dp];
% [~ ,stp]=findpeaks(dpNeg,'Threshold',0.5*(max(dpNeg)-mean(dpNeg)));

stp=find(dp<prctile(dp,500/swp_time/fs));


dstp=diff([0 ;stp]);
stp(dstp==1)=[];
dstp=diff([0 ;stp]);
[dstp_hist_n,dstp_hist_l]=hist(dstp,linspace(0,30*fs,20));
dstp_sel=dstp_hist_l(dstp_hist_n==max(dstp_hist_n));
d_range=diff(dstp_hist_l(1:2));
stp_sel=stp(abs(dstp-dstp_sel)<d_range/2);
stp_sel=stp_sel(1:end-1);

len=round(median(diff(stp_sel)));

%% adjust the stp to cover the full time range
stp_old=stp_sel;
idx_missing=[0; round(diff(stp_old)/len-1)]; %numbers of sample missing in current location(before this location)
idx_add=cumsum(idx_missing);                  %offset if old stp in new stp (cumulative)
idx_new=(1:length(stp_old))'+idx_add;    %index of old stp in new stp
Nmissing=sum(round(diff(stp_old)/len-1));
stp_sel=zeros(length(stp_old)+Nmissing,1);
stp_sel(idx_new)=stp_old;
seg_missing=(find(idx_missing));  %starting index of missing segment
for idx=1:length(seg_missing);
    tp_left=stp_old(seg_missing(idx)-1);
    tp_right=stp_old(seg_missing(idx));
    idx_fill=idx_new(seg_missing(idx)-1)+1:(idx_new(seg_missing(idx)-1)+idx_missing(seg_missing(idx)));
    val_fill=linspace(tp_left,tp_right,idx_missing(seg_missing(idx))+2);
    stp_sel(idx_fill)=val_fill(2:end-1);
end
%% 
figure(7)
plot(data_sel);
hold on;
temp=zeros(size(data,1),1);
temp(stp)=max(data_sel)+2*min(data_sel);
plot(temp,'r');
plot(mapminmax(([0 ;dp])',min(data_sel),max(data_sel)),'g')
hold off

len=round(min(diff(stp_sel)));
wave=ones(len,length(stp_sel));
gnd_wave=ones(len,length(stp_sel));
freq=linspace(swp_freq(1),swp_freq(end),len);
fs_bin=round(freq);
freq_list=unique(fs_bin);
%% 
% pks=cell(length(stp_sel),1);
Max=ones(length(stp_sel),length(freq_list));
Min=ones(length(stp_sel),length(freq_list));


for idx=1:length(stp_sel)
    temp=data_sel(stp_sel(idx):stp_sel(idx)+len-1);
    temp=temp-mean(temp);
    wave(:,idx)=(temp)/3000;
    %[p,l]=findpeaks(wave(:,idx));
    %pks{idx}=[p freq(l)'];
%     m=arrayfun(@(x) [max(wave(fs_bin==freq_list(x),idx)) ;min(wave(fs_bin==freq_list(x),idx))],1:length(freq_list),'UniformOutput',0);
%     MaxMin=cell2mat(m);
%     Max(idx,:)=MaxMin(1,:);
%     Min(idx,:)=MaxMin(2,:);
    for idy=1:length(freq_list)
        Max(idx,idy)=max(wave(fs_bin==freq_list(idy),idx));
        Min(idx,idy)=min(wave(fs_bin==freq_list(idy),idx));
    end
end
Mean=zeros([size(Max) 2]);
Mean(:,:,1)=abs(Max);
Mean(:,:,2)=abs(Min);
Mean=2*squeeze(mean(Mean,3));

figure(2)
hold on;
 shadedErrorBar(freq_list,Mean(:,:),{@median,@ste},'b') 
hold off
ylabel('Gain (V/V)');
xlabel('Frequency (Hz)')
ylim([0 1]);



figure(4);
clf
t=30*(0:size(Mean,1)-1)/60;
plot(t,mean(Mean,2)*3000);
xlabel('Time (mins)')
ylabel('Mean Peak Voltage (uV)');
% ylim([0 1400]);
%%
figure(5);
clf
plot(wave(:,1));hold on;

