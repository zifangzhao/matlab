Nch=32;
fs=20e3;
Amp=32*7.6e-6*7.5e3;
ADC_MUX=2.14e-6*Nch*fs;
sum=Amp+ADC_MUX;
f=@(x) num2str(x);
disp(['CH:' f(Nch) ' Fs:' f(fs) ' AMP_C:' f(Amp) ' ADC_MUX_C:' f(ADC_MUX) ' Total:' f(sum)]);