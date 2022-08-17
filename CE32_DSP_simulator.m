data=chirp(0:1/20000:10,1,10,1000);
d_fil=filter(single(Num),single(Den),single(data));
d_abs=abs(d_fil(1:16:end));
ma_ord=83;
d_ma=filter(ones(ma_ord,1)/ma_ord,1,d_abs);

t=(1:length(data))/20000;
t1=t(1:16:end);
plot(t,data');
hold on; 
plot(t,d_fil,'r');
plot(t1,d_abs,'g');
plot(t1,d_ma,'k');
hold off;