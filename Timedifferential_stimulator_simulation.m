fs=1000;
t=0:1/fs:1;
f1=100;
f2=102;
s1=sin(2*pi*f1.*t);
s2=sin(2*pi*f2.*t);
mix = s1+s2;
plot(t,[s1;s2],'k')
hold on;
plot(t,[mix],'r')

[b,a]=butter(2, [5/fs*2],'low');
mix_fil = filter(b,a,abs(mix));
plot(t,mix_fil,'g');
hold off;