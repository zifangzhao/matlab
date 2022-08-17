function SL=SynLikeMatrix(data,timedelay,embedding,w1,w2,p_ref,n_ref,s)
% ����Ȼͬ���ĺ�����ʹ�õķ���������T. Montez et al.  NeuroImage 33 (2006) 1117�C1125�еķ��� 
%X�źž���ÿ����һ���ź�
% timedelay ��ռ��ع�ʱ��ʱ���ӳ�
% embedding Ƕ��ά��
% w1 w2�Ǵ��������������������е�w1��w2��һ��
%p_ref ���ʣ���ȡ0.01��0.05 ��0.1��
%sÿ�ε������ȣ�Ĭ��Ϊ1���������ٶȻ���
%ע�⣺�˷������ݳ���һ��Ҫ�㹻���������޷�����

% ��������ʵ��
% �����������ף������˲�����ź�Ƶ��Ϊ3-20hz���źŲ���Ƶ��fs=100; 
% ��
% HF=20;
% LF=3;
% timedelay=max(floor(fs/HF/3),1);
% embedding=max(floor(3*HF/LF)+1,1);
% w1=max(timedelay*(embedding-1),1);% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C1125�е�w1��һ��
% p_ref=0.05; %
% n_ref=10;   %
% w2=ceil(n_ref/p_ref/2)+w1-1;% ����T. Montez et al. / NeuroImage 33 (2006) 1117�C1125�е�w2��һ��
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
lengthWindow=2*(w2-w1+1);%���ڵĵ���
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
%�ҵ�k����Сֵ
%x��һ��������������������������
%k��Сʱ���ô˺����Ͽ� ��k̫�����ô˺����Ͳ�������


for n=1:(k-1)
    [a,I]=min(x);
    x(I)=[];
end
a=min(x);
    
            


        