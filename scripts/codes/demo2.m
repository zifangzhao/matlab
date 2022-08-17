clear all
clc
fs=100;
T=6;
t=([1:fs*T+1]-1)/fs;
xx=1*sin(2*pi*3*t)+4*sin(2*pi*10*t)+6*sin(2*pi*20*t)+0.5*rand(1,length(t));
lag=1*fs;
x=xx(1:(length(t)-lag));
y=x+0.5*rand(1,length(t)-lag);%6*sin(2*pi*20*t(lag+1:end))+1*rand(1,length(t)-lag);
z=randn(1,length(t)-lag);%1*sin(2*pi*3*t(1:(length(t)-lag)));

data=[x;y;z]; %三个通道的数据，每行是一个通道的信号

%参数设置
fs=100; %信号采样频率
HF=20;
LF=3;
timedelay=max(floor(fs/HF/3),1);% L
embedding=max(floor(3*HF/LF)+1,1);% m
w1=max(timedelay*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w1的一半
p_ref=0.05;
n_ref=10;
w2=ceil(n_ref/p_ref/2)+w1-1;% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w2的一半
s=max(floor(w1),1);%1

tic
SL1=SynLikeMatrix(data,timedelay,embedding,w1,w2,p_ref,n_ref,s) 
%SL第一种方法 数据得足够长，否则无法计算
%s略大些，速度会快
toc

w=max(2*timedelay*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w1
tic
SL2=SynLikeMatrix2(data,timedelay,embedding,w,p_ref)
%SL第二种方法，数据一定不能长，否则非常非常慢
toc








