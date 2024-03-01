file = 'F:\hpc_ctx_project\HP01\day1\post_sleep_1_240227_123124\amplifier.dat';
lfpfile = strrep(file,'.dat','.lfp');
if isempty(dir(lfpfile))
    dat2lfp_frank(file);
end
ch  = [111 83]+1; %ripple , SPW
data = readmulti_frank(lfpfile,128,ch,0,inf);
data_1000 = resample(data,1000,1250);
data_rip = data_1000(:,1);
data_spw = data_1000(:,2)-data_rip;
fs=1000;
%% generate ground truth
det_file = DAT_oscillationDetector(lfpfile,ch(1),'RIP',[100 200],[3 5]);

%% proc data with CL02 simulator
fileLPF_rip = 'fdacoefs_LPF_R1_50Hz@1000_ord1_SOS.h';
fileBPF_rip = 'fdacoefs_BPF_R1_100_200Hz@1000_ord1_SOS.h';
[env_ripple,BPF_rip,LPF_rip]= CL02_filter_sim(data_rip,fileBPF_rip,fileLPF_rip);

fileLPF_spw = 'fdacoefs_LPF_SPW_5Hz@1000_ord1_SOS.h';
fileBPF_spw = 'fdacoefs_BPF_SPW_12_30Hz@1000_ord1_SOS.h';
[env_spw,BPF_spw,LPF_spw]= CL02_filter_sim(data_spw,fileBPF_spw,fileLPF_spw);
%% ideal filter
[b_rip,a_rip] = butter(1,[100, 200]/fs*2,'bandpass');
env_ripple_ideal = abs(hilbert(filtfilt(b_rip,a_rip,data_rip)));

[b_spw,a_spw] = butter(1,[12, 30]/fs*2,'bandpass');
% [b_spw,a_spw] = butter(1,[3, 12]/fs*2,'bandpass');
env_spw_ideal = abs(hilbert(filtfilt(b_spw,a_spw,data_spw)));
%% serial filter
[b_rip_lpf,a_rip_lpf] = butter(1,[50]/fs*2,'low');
[b_spw_lpf,a_spw_lpf] = butter(1,[5]/fs*2,'low');
env_ripple_serial = filter(b_rip_lpf,a_rip_lpf,abs(filter(b_rip,a_rip,data_rip)));
env_spw_serial = filter(b_spw_lpf,a_spw_lpf,abs(filter(b_spw,a_spw,data_spw)));

%%  fvtool
fvtool(BPF_spw,'fs',1000);
fvtool(b_spw,a_spw,'fs',1000);
fvtool(LPF_spw,'fs',1000);
fvtool(b_spw_lpf,a_spw_lpf,'fs',1000);
%% serial filter with MA
[b_rip_ma] = ones(10,1)/10;
[b_spw_ma] = ones(100,1)/100;
env_ripple_ma = filter(b_rip_ma,1,abs(filter(b_rip,a_rip,data_rip)));
env_spw_ma = filter(b_spw_ma,1,abs(filter(b_spw,a_spw,data_spw)));

%% output rst
data_out = [data_1000/5 env_ripple_ideal env_spw_ideal env_ripple_serial env_spw_serial env_ripple_ma env_spw_ma env_ripple env_spw]*5;
sav2dat(strrep(file,'.dat','_filDebug_fs1000.dat'),data_out);

%% performance analysis
evt = LoadEvents(det_file);
trig_time = evt.time(1:3:end);
win = 0.5*fs;
figure(1);
trig_sps = round(trig_time*fs);
trig_sps(trig_sps<win)=[];
trig_sps(trig_sps>length(data_out)-win)=[];
DTP = arrayfun(@(x) data_out(x-win:x+win,:),trig_sps,'uni',0);
DTP = cat(3,DTP{:});
DTP = median(DTP,3);
% DTP = bsxfun(@minus,DTP,median(DTP,1));
t=(-win:win)/fs;
DTP_disp = DTP(:,[1 3 5 7 9 2 4 6 8 10]);
DTP_disp = bsxfun(@minus,DTP_disp,2000*(1:size(DTP,2)));
plot(t,DTP_disp);
[~,pks]=max(DTP(:,3:end),[],1);
pks=arrayfun(@(x) find(DTP(:,x)>1.5*mean(DTP(:,x),1),1,'first'),3:size(DTP,2));
dly = t(pks);
snr = max(DTP,2)./mean(DTP,2);

% pks = zeros(size(DTP,2),1);
% snr = zeros(size(DTP,2),1);
% dly = zeros(size(DTP,2),1);
% for ch=1:size(DTP,2)
%      [p,locs,widths,proms]= findpeaks(DTP(:,ch),'WidthReference','halfheight');
%      idx_sel =t(locs)>=-0.1;
%      locs =locs(idx_sel);
%      widths=widths(idx_sel);
%      p = p(idx_sel);
%      proms = proms(idx_sel);
%      [max_prom,ix]=max(proms);
%      pks(ch)=p(ix);
%      snr(ch) = max_prom./p(ix);
%      dly(ch) = t(locs(ix))-widths(ix)/2/fs;
% end

names = {'R(ideal)','S(ideal)','R(sim)','S(sim))','R(MA)','S(MA))','R(device)','S(device))'};
dispstr = ["ch1","ch2",arrayfun(@(x) [names{x} ':' num2str(dly(x)*1000) 'ms '],1:length(names)','uni',0)];
% dispstr = cat(2,dispstr{:});
% title(dispstr)
legend(dispstr([1 3 5 7 9 2 4 6 8 10]))
