%% Detect band activity based on FMAToolbox
function detect_band_event(filename)
if nargin<1
[f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files'},'MultiSelect','Off');
filename=[p f]; 

 
end
[Nch,fs,Nsamples,~,good_ch,time_bin]=DAT_xmlread(filename);
LFP=readmulti_frank(filename,Nch,good_ch,0,inf);
%%
for ch=1:Nch
    fprintf(2,['Detecting Gamma Events:' num2str(ch) '/' num2str(Nch) '\n'])
    t=(1:size(LFP,1))'/fs;
    fil= FilterLFP([t LFP(:,ch)], 'passband', [50 80]);
    [gamma,sd,bad] = FindRipples(fil,'thresholds', [2 5], 'durations', [30 60 300]);
    fil= FilterLFP([t LFP(:,ch)], 'passband', [100 250]);
    fprintf(2,['Detecting Ripple Events:' num2str(ch) '/' num2str(Nch) '\n'])
    [rip,sd,bad] = FindRipples(fil,'thresholds', [2 5], 'durations', [30 20 100]);
    LFP_events(ch).gamma=gamma;
    LFP_events(ch).ripple=rip;
    DAT_SaveEvents([filename(1:end-4) '.gam.evt'],gamma,ch,'Gamma');
    DAT_SaveEvents([filename(1:end-4) '.rip.evt'],rip,ch,'Ripple');
end

save([filename(1:end-4) '_LFPEvents'],'LFP_events');