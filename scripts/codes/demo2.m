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

data=[x;y;z]; %����ͨ�������ݣ�ÿ����һ��ͨ�����ź�

%��������
fs=100; %�źŲ���Ƶ��
HF=20;
LF=3;
timedelay=max(floor(fs/HF/3),1);% L
embedding=max(floor(3*HF/LF)+1,1);% m
w1=max(timedelay*(embedding-1),1);% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C1125�е�w1��һ��
p_ref=0.05;
n_ref=10;
w2=ceil(n_ref/p_ref/2)+w1-1;% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C1125�е�w2��һ��
s=max(floor(w1),1);%1

tic
SL1=SynLikeMatrix(data,timedelay,embedding,w1,w2,p_ref,n_ref,s) 
%SL��һ�ַ��� ���ݵ��㹻���������޷�����
%s�Դ�Щ���ٶȻ��
toc

w=max(2*timedelay*(embedding-1),1);% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C1125�е�w1
tic
SL2=SynLikeMatrix2(data,timedelay,embedding,w,p_ref)
%SL�ڶ��ַ���������һ�����ܳ�������ǳ��ǳ���
toc








