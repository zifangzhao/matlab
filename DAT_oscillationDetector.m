%% Detect band activity based on FMAToolbox
function outputfile=DAT_oscillationDetector(filename,ch,EvtIdentify,freq_range,power_thre,durations)
% 
%duration : [int min max]
if nargin<1
    [f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files'},'MultiSelect','Off');
    filename = [p f];
end
if nargin<3
    EvtIdentify = 'evt';
end
if nargin<4
    freq_range = [30 80];
end

if nargin<5
    power_thre = [2,5];
end

if nargin<6
    durations = [30 30 600];
end
[Nch,fs,~,~,good_ch,~]=DAT_xmlread(filename);
data=readmulti_frank(filename,Nch,ch,0,inf);

% LFP_events=cell(Nch,1);
%%
LFP_events=data_processer(filename,data,ch,fs,freq_range,power_thre,durations,EvtIdentify);

ch_str = ['_CH' num2str(ch)];
freq_str =['_L' num2str(freq_range(1))  'H' num2str(freq_range(2))];
power_str = ['_std' num2str(power_thre(1)) '-' num2str(power_thre(2))];
dur_str = ['_T' num2str(durations(1)) '_' num2str(durations(2)) '_' num2str(durations(3))];
outputfile=[filename(1:end-4) '_' EvtIdentify ch_str freq_str power_str dur_str];
save(outputfile,'LFP_events');

end
function LFP_events=data_processer(filename,data,ch,fs,freq,power,duration,EvtIdentify)

t=(1:size(data,1))'/fs;
fil_gam= FilterLFP([t data], 'passband', freq,'nyquist',fs/2);
[gamma,sd,bad] = FindRipples(fil_gam,'thresholds', power, 'durations', duration,'frequency',fs,'stdev',median(fil_gam(:,2).^2));
LFP_events.time=gamma;
freq_str =['L' num2str(freq(1))  'H' num2str(freq(2))];
DAT_SaveEvents([filename(1:end-4) '_' freq_str '_CH' num2str(ch-1,'%.3d') '.' EvtIdentify '.evt'],gamma,ch-1,freq_str);

end

