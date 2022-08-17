%% script for calculate wavelet for DAT structure
function wavelet=DAT_struct_wavelet(DAT,freqlist)
% Load dat structure
% [f,p]=uigetfile('*.*.mat','Select mat file contain DAT structure');
% load([p f]);
% 
% freqlist=1:200;

fs=DAT.fs;

%% calculate wavelet
wavelet=cellfun(@(x) awt_freqlist_multirow(x,fs,freqlist,'Gabor'),DAT.data,'UniformOutput',0);