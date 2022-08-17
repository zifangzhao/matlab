%% manchester bandwidth simulation
fs=20e6;
man_fs=2e6;
Len=man_fs*2;
data=round(rand(Len,1));
data_man=reshape([data ~data]',1,[]);
data_raw=reshape((data_man'*ones(1,fs/man_fs/2))',1,[]);
data_raw=data_raw-mean(data_raw);
%% FFT

Y=fft(data_raw,fs);
N=length(Y)/2;
f=linspace(0,fs/2,N)/1e6;
plot(f,20*log10(abs(2*Y(1:N))));
set(gca,'xtick',0:1:10)
xlabel('Frequency(MHz)')
ylabel('Power(dB)')