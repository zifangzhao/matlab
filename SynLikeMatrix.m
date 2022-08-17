function SL=SynLikeMatrix(data,timedelay,embedding,w1,w2,p_ref,n_ref,s)
% 求似然同步的函数，使用的方法是文献T. Montez et al.  NeuroImage 33 (2006) 1117–1125中的方法 
%X信号矩阵，每行是一个信号
% timedelay 相空间重构时的时间延迟
% embedding 嵌入维数
% w1 w2是窗参数，但是上面文献中的w1、w2的一半
%p_ref 概率，可取0.01或0.05 或0.1等
%s每次递增长度，默认为1，但计算速度会慢
%注意：此方法数据长度一定要足够长，否则无法计算

% 参数设置实例
% 按照上述文献，比如滤波后的信号频段为3-20hz，信号采样频率fs=100; 
% 则
% HF=20;
% LF=3;
% timedelay=max(floor(fs/HF/3),1);
% embedding=max(floor(3*HF/LF)+1,1);
% w1=max(timedelay*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w1的一半
% p_ref=0.05; %
% n_ref=10;   %
% w2=ceil(n_ref/p_ref/2)+w1-1;% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w2的一半
% s=max(floor(w1),1);%1
%Edited by Yanning Wang



if nargin<8
    s=1;
end
[m,R]=size(data);

N=R-(embedding-1)*timedelay;
%if N<2*w2+1
%    error('the length of sign is too short!!!')
%end
X=zeros(m,embedding,N);

%Embedd vectors
%    function X=PhaseRestruction(x,timedelay,embedding)
for t=1:m
    for n=1:embedding
        X(t,n,:)=data(t,(n-1)*timedelay+1:(n-1)*timedelay+N);
    end
end
%Calculate distance between embedded vectors
Index=[1+w2:s:N-w2];
lengthIndex=length(Index);
lengthWindow=2*(w2-w1+1);%窗内的点数
dx=zeros(m,lengthIndex,lengthWindow);
for t=1:m
    for k=1:lengthIndex
        i=Index(k);
        winIndex=[i-w2:i-w1,i+w1:i+w2];
        for n=1:lengthWindow    
            j=winIndex(n);
            dx(t,k,n)=norm(X(t,:,i)-X(t,:,j),2);
        end            
    end
end
        
% Estimate critical distance signal x
rx=zeros(m,lengthIndex);
for t=1:m
    for k=1:lengthIndex
        i=Index(k);
        rx(t,k)=kmin(dx(t,k,:),n_ref);
    end
end
   
    
% estimating simultaneous repetitions
SL=zeros(m,m);
sli=zeros(1,lengthIndex);
for t=1:m-1
    for tt=(t+1):m
        for k=1:lengthIndex
            sli(k)=mean((dx(t,k,:)<=rx(t,k)).*(dx(tt,k,:)<=rx(tt,k)));
        end
        SL(t,tt)=mean(sli)/(p_ref);
    end
end
SL=SL+SL';


function a=kmin(x,k)
%找第k个最小值
%x是一个向量，行向量、列向量均可
%k较小时，用此函数较快 ；k太大了用此函数就不合适了


for n=1:(k-1)
    [a,I]=min(x);
    x(I)=[];
end
a=min(x);
    
            


        