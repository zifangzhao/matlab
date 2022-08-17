%script for calculating the gain of the sweep mode
%% file loading
fname=uigetfile('*.dat');
% t=regexpi(fname,'HD32BR(\d)','tokens');
% if  str2double(t{1})==5
%     Vref=3.3;
% else
%     Vref=2.42;
% end
% chnnum=32;
% t=regexpi(fname,'_(\d+)K','tokens');
% fs_mux=str2double(t{1}{1})*1e3;
% swp_time=30; %sweep time in second
% swp_freq=[0.1 500];
Vref=3.3;
fs_mux=40e3;
chnnum=32;
swp_time=10; %sweep time in second
swp_freq=[1 500];
sig_amp=15e3/7.5;
t_start=50;
t_end=1500;
fs=fs_mux/chnnum;

convert_eff=1/65535*Vref/300*1e6;
data=readmulti_frank(fname,chnnum,1:chnnum,t_start*fs,t_end*fs)*convert_eff;
data=data(fs*300:end,:);
%%
data=data-(median(data,1)'*ones(1,size(data,1)))';

offset=([size(data,2):-1:1]'*ones(1,size(data,1)))';
% plot(data+2000*offset);

sel_chn=15%22;
gnd_chn=14%23;


p=awt_freqlist(data(:,sel_chn),fs,swp_freq(end),'Gabor');
dp=diff(smooth(abs(p),15));
stp=find(dp<prctile(dp,1000/swp_time/fs));
dstp=diff([0 ;stp]);
stp(dstp==1)=[];
dstp=diff([0 ;stp]);
[dstp_hist_n,dstp_hist_l]=hist(dstp,linspace(0,30*fs,20));
dstp_sel=dstp_hist_l(dstp_hist_n==max(dstp_hist_n));
d_range=diff(dstp_hist_l(1:2));
stp_sel=stp(abs(dstp-dstp_sel)<d_range/2);
stp_sel=stp_sel(1:end-1);

figure(7)
plot(data(:,sel_chn));
hold on;
temp=zeros(size(data,1),1);
temp(stp_sel)=max(data(:,sel_chn))+2*min(data(:,sel_chn));
plot(temp,'r');
hold off

len=round(median(diff(stp_sel)));
wave=ones(len,length(stp_sel));
gnd_wave=ones(len,length(stp_sel));
freq=linspace(swp_freq(1),swp_freq(end),len);
fs_bin=round(freq);
freq_list=unique(fs_bin);

% pks=cell(length(stp_sel),1);
Max=ones(length(stp_sel),length(freq_list));
Min=ones(length(stp_sel),length(freq_list));
gnd_Max=ones(length(stp_sel),length(freq_list));
gnd_Min=ones(length(stp_sel),length(freq_list));

stp_sel(stp_sel+len-1>size(data,1))=[];

for idx=1:length(stp_sel)
    temp=data(stp_sel(idx):stp_sel(idx)+len-1,sel_chn);
    temp=temp-mean(temp);
    
    gnd_temp=data(stp_sel(idx):stp_sel(idx)+len-1,gnd_chn);
    gnd_temp=gnd_temp-mean(gnd_temp);
    
    wave(:,idx)=(temp)/sig_amp;
    gnd_wave(:,idx)=gnd_temp/sig_amp;
    %[p,l]=findpeaks(wave(:,idx));
    %pks{idx}=[p freq(l)'];
%     m=arrayfun(@(x) [max(wave(fs_bin==freq_list(x),idx)) ;min(wave(fs_bin==freq_list(x),idx))],1:length(freq_list),'UniformOutput',0);
%     MaxMin=cell2mat(m);
%     Max(idx,:)=MaxMin(1,:);
%     Min(idx,:)=MaxMin(2,:);
    for idy=1:length(freq_list)
        Max(idx,idy)=max(wave(fs_bin==freq_list(idy),idx));
        Min(idx,idy)=min(wave(fs_bin==freq_list(idy),idx));
        
        gnd_Max(idx,idy)=max(gnd_wave(fs_bin==freq_list(idy),idx));
        gnd_Min(idx,idy)=min(gnd_wave(fs_bin==freq_list(idy),idx));
    end
end
Mean=zeros([size(Max) 2]);
Mean(:,:,1)=abs(Max);
Mean(:,:,2)=abs(Min);
Mean=2*squeeze(mean(Mean,3));

gnd_Mean=zeros([size(Max) 2]);
gnd_Mean(:,:,1)=abs(gnd_Max);
gnd_Mean(:,:,2)=abs(gnd_Min);
gnd_Mean=2*squeeze(mean(gnd_Mean,3));

figure(2)
hold on;
% shadedErrorBar(freq_list,Max,{@median,@std},'r') 
% shadedErrorBar(freq_list,Min,{@median,@std},'g') 
 shadedErrorBar(freq_list,Mean(:,:),{@median,@ste},'b') 
 save gain freq_list Mean
hold off
ylabel('Gain (V/V)');
xlabel('Frequency (Hz)')
ylim([0 1]);

figure(3);
 shadedErrorBar(freq_list,gnd_Mean(:,:),{@median,@ste},'b') 
 hold off
ylabel('Gain (V/V)');
xlabel('Frequency (Hz)')
ylim([0 1]);

figure(4);
plot(Mean(5,:));hold on;
plot(gnd_Mean(5,:));
hold off
%%
figure(5);
plot(wave(:,1));hold on;
plot(gnd_wave(:,1));
hold off
%%
figure(6);
CrossTalk=20*log10(gnd_Mean(1,:)./Mean(1,:));
plot(CrossTalk)

save(fname(1:end-4),'wave','gnd_wave','freq_list','Mean','Min','Max','gnd_Mean');