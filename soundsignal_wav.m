function soundsignal_wav(signal)
fs=20000;
len=0.1;
t=linspace(0,len,fs*len);
data=0.5+0.5*cos(2*pi*signal*t);
sound(data,fs);



