function data_filtered=fft_filter(rawdata,HP,HS,fs)
%fatal error ifft parameter did not give, revised @ 12/17/13
%revised by zifang zhao 2014-6 fix out put from 2*real(ifft(Y,N,2) to
%real(ifft(Y,N,2)
if size(rawdata,2)==1
    rawdata=rawdata';
end
Data_size=size(rawdata);
N=size(rawdata,2);

Y=fft(rawdata,N,2);  %得到原信号的频域表征
clear('rawdata');
HP_d=floor(HP*N/fs)+1;
HS_d=round(HS*N/fs);
BP_d=zeros(Data_size);
BP_d(:,HP_d:HS_d)=1;
BP_d(:,end-HS_d:end-HP_d)=1;

Y=Y.*BP_d;clear('BP_d');
data_filtered=real(ifft(Y,N,2));
end