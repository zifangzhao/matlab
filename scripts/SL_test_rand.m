%random signal SL test
sys_fs=1000;
data_len=5000;
HF=30;
LF=13;
res_fs=HF*3;
n_rec=10;
p_ref=0.05;
sampling_delay=floor(fs./HF/3);% L
embedding=floor(3*HF./LF)+1;% m
w1=sampling_delay.*(embedding-1);
w2=ceil((n_rec/p_ref+2*w1-1)/2);

test_trial=50;
SL_mul=cell(test_trial,1);
parfor idx=1:test_trial;
%信号生成
chA=randn(1,data_len);
chB=randn(1,data_len);

chA=mapminmax(chA,0,1);
chB=mapminmax(chB,0,1);
fft(chA);
y=fft(chA);
x=logspace(0,2,length(y)/2);
loglog(x,2*abs(y(1:end/2)))

xlabel('Frequency (Hz)')
ylabel('Power (dB)')

%通过sin函数产生片段
seg_len=200;
seg_fs=20;  %产生的信号频率为20Hz
tim1=200+w2;
tim2=450+w2;
data_seg=sin(2*pi*(seg_fs/sys_fs)*(1:seg_len))/10;
chA(tim1:length(data_seg)+tim1-1)=chA(tim1:tim1+length(data_seg)-1)+data_seg;
chB(tim2:length(data_seg)+tim2-1)=chB(tim2:tim2+length(data_seg)-1)+data_seg;

%滤波
chA=resample(chA,res_fs,sys_fs);
chA=hwt(chA,LF,HF,res_fs);
chB=resample(chB,res_fs,sys_fs);
chB=hwt(chB,LF,HF,res_fs);


%analysis
stps=500;
delays=500;
%改变时间单位
stps_fixed=0:(stps.*fs/1000);
delays_fixed=0:(delays.*fs/1000);
SL_mul{idx}=SL_single_twosided(chA',chB',w1,w2,embedding,sampling_delay,p_ref,stps_fixed,delays_fixed);

end
SL=zeros(size(SL_mul{1}));
for i=1:test_trial
    SL=SL_mul{i}+SL;
end
SL=SL./test_trial;

figure(2)
imagesc(stps_fixed*1000/fs,delays_fixed*1000/fs,SL); axis xy;
figure(3)
tim=(1000/fs).*((1:length(chA))-1);
subplot(211);plot(tim,chA);
ylabel('uV')
xlabel('ms')

subplot(212);plot(tim,chB);
xlabel('ms')
ylabel('uV')

