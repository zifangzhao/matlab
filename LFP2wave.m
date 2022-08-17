%% wavelet calculation based on collected LFP
uiopen('*.mat');
freqlist=1:2:50;
%% 
Wave_all=cell(1,length(LFP_all));
for f_idx=1:length(Wave_all)
    fs=LFP_all{f_idx}.fs;
    Wave_all{f_idx}.pre=cellfun(@(x) awt_freqlist_multirow(x,fs,freqlist,'Gabor'),LFP_all{f_idx}.pre,'UniformOutput',0);
    Wave_all{f_idx}.post=cellfun(@(x) awt_freqlist_multirow(x,fs,freqlist,'Gabor'),LFP_all{f_idx}.post,'UniformOutput',0);
    Wave_all{f_idx}.fs=fs;
    Wave_all{f_idx}.name=LFP_all{f_idx}.name;
end
uisave('Wave_all','Wave_all');