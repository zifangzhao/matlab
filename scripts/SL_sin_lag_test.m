data_len=1e5;
sys_fs=100;
f=5;
p=sys_fs/f;
% 4Hz @ 25points period
A=sin((1:data_len)*2*pi/p);
B=sin((1:data_len)*2*pi/p);


HF=8;
LF=4;
res_fs=HF*3;
n_rec=10;
p_ref=0.05;
sampling_delay=floor(res_fs./HF/3);% L
embedding=floor(3*HF./LF)+1;% m
w1=sampling_delay.*(embedding-1);
w2=ceil((n_rec/p_ref+2*w1-1)/2);

%ÂË²¨
chA=resample(A,res_fs,sys_fs);
chA=hwt(chA,LF,HF,res_fs);
chB=resample(B,res_fs,sys_fs);
chB=hwt(chB,LF,HF,res_fs);


stps=500;
delays=500;
stps_fixed=0:(stps.*res_fs/1000);
delays_fixed=0:(delays.*res_fs/1000);

SL_mul=SL_single_twosided(chA',chB',w1,w2,embedding,sampling_delay,p_ref,stps_fixed,delays_fixed);
