%% ECG properties
figure(1)
fs=500;
subplot(2,5,6:9)
plot(t,sig);
hold on;
[b,a]=butter(3,[0.5*2/fs,45*2/fs],'bandpass');
plot(t,filtfilt(sig));
hold off;
xlim([0,5]);
p=awt_freqlist(sig,500,flist,'Gabor');
subplot(2,5,[1:4]);
imagesc(t,flist,abs(p)');
xlabel('Time(s)');
ylabel('Frequency(Hz)');
axis xy;
caxis([0 20]);
xlim([0 5]);
subplot(2,5,5);
plot(flist,median(abs(p),1));
ylabel('Amplitude(uV)');
view(90,-90);