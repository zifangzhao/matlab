%%script for extract spike from specific channel from NEV matlab files
[f p]=uigetfile('*.mat','Open NEV matlab file');
load([p f]);
%%
CH_list=unique(NEV.Data.Spikes.Electrode)';
idx=CH_list;
str=num2str(idx);
[s,v] = listdlg('PromptString','Select a channel:',...
                'ListString',str);
ch_sel=idx(s);
%% 
AllUnits=NEV.Data.Spikes.Electrode==ch_sel;
unit_num=double(max(NEV.Data.Spikes.Unit(AllUnits)))+1;
m=round(double(unit_num)^0.5);
n=ceil(double(unit_num)^0.5);
Fc=300;
Fs=NEV.MetaTags.TimeRes;
[b,a]=butter(n,2*Fc/Fs,'high');
t=(1:size(NEV.Data.Spikes.Waveform,1))/Fs*1000;
for idx=1:unit_num
    subplot(m,n,idx)
    unit_sel=AllUnits&(NEV.Data.Spikes.Unit==(idx-1));
    wave=double(NEV.Data.Spikes.Waveform(:,find(unit_sel))');
    wave=filtfilt(b,a,wave')';
    shadedErrorBar(t,wave,{@mean,@std});
    xlabel('ms');
    ylabel('uV')
    axis tight
end
