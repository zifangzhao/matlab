%% wavelet compare to fft
function waveplot(data,fs,wname,ws,t_start,filename)
cwd=pwd;
cd('\\lab000-pc\mdce\pic');
matfile=dir('*.mat');
for n=1:length(matfile)
    load(matfile(n).name);
end
% systemfs=1000;
% time_selected=[150 152];
% fs=200;
% data=resample(elec10(time_selected(1)*systemfs:time_selected(2)*systemfs),fs,systemfs);

% close all;

% wname='sym4';
% ws=1:100;
splot=1;
t=0:1/fs:(length(data)-1)/fs;
t=t+t_start;
% figure(1)
% subplot(splot,1,1);
% plot(t,data)
% colorbar
%% wavelet

h2=figure(2);
[c,s]=cwt(data,ws,wname,'scal','plot');
print('-djpeg90',['Scalogram of ' filename]);



%% FFT plot
h3=figure(3);
L=length(data);
NFFT = 128; % Next power of 2 from length of y
Y = fft(data,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlim([0 200])
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
print('-djpeg90',['FFT of ' filename]);


cd(cwd);

% close(h1);
% close(h2);
% close(h3);
