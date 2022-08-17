% Surrogate generater test
Y=fft(data);
rot_1=exp(rand(length(Y)/2,1)*2*pi*1i);
rot=[rot_1 ; flipud(rot_1)];
Y1=Y.*rot;
x=(ifft(Y1));