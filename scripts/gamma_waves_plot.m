clear
clc 
close all
%% Loading gamma times 
f=uigetfile('gamma.mat');
load(f);
% matfile=load(f);
% field=fieldnames(matfile);
% gamma=getfield(matfile,field{1});
HD32_B_map=[23 22 21 19 18 17 8 9 10 12 13 14 15 11 16 20 27 31 4 0 1 2 3 5 6 7 30 29 28 26 25 24 ]+1;
HD32_B_map(18)=[];
gamma_start=gamma(:,1);
gamma_end=gamma(:,3);
% gamma_res=(gamma_start+gamma_end)/2;  % units in second
gamma_res=gamma(:,2);
%% loading data 
Rs=1250;
filename=dir('*.lfp');
time= round (gamma_res*1250); % units in data point
duration=2*Rs; %units in data point % make sure it is long enough for filtering
CH_N=32;
Data=Dat_tracker(filename.name,time, duration, CH_N);
conv_eff=1/65535*3.3/300*1e6; 
Data=Data*conv_eff;
%%
figure(1);
t=(1:size(Data,2))/Rs*1000;
t=t-t(end/2);
for trial=16
   gamma_lfp=squeeze(Data(:,:,trial));
%    for i=1:CH_N
%       subaxis(32,1,i, 'Spacing', 0.01, 'Padding', 0, 'Margin', 0.01);
%       plot(gamma_lfp(HD32_B_map(i),:)); axis tight; ylim([-1500 1500]);
% %       axis_cleaner; 
%    end
%     
      plot(t,bsxfun(@plus,gamma_lfp(HD32_B_map,:)',-200*(1:length(HD32_B_map)))); axis tight;
      %       ylim([-1500 1500]);
      xlim([-500 500])
    xlabel('Time(ms)')
    set(gca,'ytick',[])
end
%%
% fc= [30 80];
% filter_type='bandpass';
% n=1;
% Wn=fc;
% [b,a]=butter(n,2*Wn/Rs,filter_type);
figure(2)

    Fs = 1250;  % Sampling Frequency
    
    Fstop1 =25;         % First Stopband Frequency
    Fpass1 = 30;         % First Passband Frequency
    Fpass2 = 80;         % Second Passband Frequency
    Fstop2 = 85;         % Second Stopband Frequency
    Astop1 = 60;          % First Stopband Attenuation (dB)
    Apass  = 1;           % Passband Ripple (dB)
    Astop2 = 60;          % Second Stopband Attenuation (dB)
    match  = 'stopband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
        Astop2, Fs);
    Hd = design(h, 'butter', 'MatchExactly', match);

% figure_ctrl('filtered LFP at gamma', 200,1000);
for trial=16
   gamma_lfp=squeeze(Data(:,:,trial));
%    gamma_fil=filtfilt(b,a,gamma_lfp);
   gamma_fil=filtfilt(Hd.sosMatrix,Hd.ScaleValues,gamma_lfp')';
   plot(t,bsxfun(@plus,gamma_fil(HD32_B_map,:)',-100*(1:length(HD32_B_map)))); axis tight;
   xlim([-500 500])
    xlabel('Time(ms)')
    set(gca,'ytick',[])
    
end
%%

tmp=filtfilt(Hd.sosMatrix,Hd.ScaleValues,Data(30,:,1));
tmp=0.7*tmp(end/2-500:end/2+500);
r=max(tmp)-min(tmp);
gamma_fil=cell(32,1);
sos=Hd.sosMatrix;
g=Hd.ScaleValues;
parfor chn=1:32
    gamma_lfp=squeeze(Data(chn,:,:));
    gamma_fil{chn}=filtfilt(sos,g,gamma_lfp);
end
%%
figure(3);
clf
hold on;
for chn=1:length(HD32_B_map)
    % shadedErrorBar(t,gamma_fil',{@median,@ste},'b')
    plot(t,-0.2*r*chn+median(gamma_fil{HD32_B_map(chn)},2),'r')
end
axis tight
xlim([-100 100])
xlabel('Time(ms)')
set(gca,'ytick',[])

hold off;


