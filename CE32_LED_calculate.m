Kist=900;
Rist=10e3;
R1=10e3;

Vdc=0:0.1:3.3;

I=Kist*(1.229/Rist+(1.229-Vdc)/R1);

plot(Vdc,I*1000);
xlabel('Vdc(Volt)');
ylabel('Iout(mA)');