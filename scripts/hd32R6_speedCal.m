%HD32R6 speed calculation
Re=1.5e3;
Ce=15e-9;
Cs=100e-12;
Cd=10e-12;
Rsd=1e3;
Y_all=cell(50,1);
for idx=1:length(Y_all)
F=1/1e8;
fs=640e3;
t=1/fs;
t_all=32*t;
sig=zeros(1,round(t_all/F)); %time in ns
% sig(end/2:end/2+t/F)=1;
data=rand(length(sig(x:round(t/F):end))+1,1);
for x=1:round(1*(t/F)) %duty cycle control
sig(x:round(t/F):end)=data(1:length(sig(x:round(t/F):end)));
end
sig=sig-mean(sig);
Y=abs(fft(sig));
Y=Y(1:round(length(Y)/2));
freq=linspace(0,1/2/F,length(Y));
plot(freq,Y)
Y_all{idx}=Y;
end
Y_mean=zeros(size(Y_all{1}));
for idx=1:length(Y_all)
    Y_mean=Y_mean+Y_all{idx}/length(Y_all);
end
plot(freq,Y_mean)