% Data analysis script for stimulation analysis
% Use the Data_load first
% created by Zifang Zhao @ 2014-4-28
fs=2e4;
fs_r=1e3;
EEG_d=fft_filter(EEG_denoise',0,1000,fs)';
EEG_d=resample(EEG_d,fs_r,fs);
%% Look at the frequency distribution first
chn=1;
[s,f,t,p]=spectrogram(squeeze(EEG_d(:,chn)),1000,500,1000,fs_r);
imagesc(f,t,p);
axis xy;
