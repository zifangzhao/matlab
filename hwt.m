function x_hwt=hwt(x,f1,f2,fs)
% 2012-4-13 revised by Zifang Zhao
% extract desired frequency band component of signal: f1-f2;
% x is the signal to be decomposed,size of N*1
% fs is the sampling frequency


N=length(x);
xsize=size(x);
if xsize(1)==1
x=x';
end

X=fft(x,N); % N points FFT of the signal
df1=floor(f1*N/fs)+1; % convert the analogue frequency to digital form
df2=round(f2*N/fs);
BW=zeros(N,1);
XW=zeros(N,1);
%W=hann(df2-df1+1);% hanning window
% for i=df1:df2 
% BW(i)=1;% wavelet function in frequency domain, only the desired band nonzero
% %BW(i)=1*W(i-df1+1);% hanning window used to improve the localization
% %in time domain
% end
BW(df1:df2)=1;


XW(df1:df2)=X(df1:df2).*conj(BW(df1:df2));% multiplication in frequency domain

x_hwt=2*real(ifft(XW));