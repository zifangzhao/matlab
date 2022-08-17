%HD128 V5 parameter calculation

%% conn
%tps79301
R1=(5/1.2246-1)*30e3
R1=100e3;
R2=33e3;
C1=(3e-7)*(R1+R2)/(R1*R2) 
%12P
V0=1.2246*(1+R1/R2)

%TPS72301
R2=22e3
R1=100e3-R2
R1=75E3
R1=82e3
V0=-1.186*(1+R1/R2)

%%hd16
%filter
R1=510e3;
C1=1e-6;
R2=51;
C2=1e-9;
Rg=9.9e3/(300-1)

R3=100
C3=1/(2*pi*R3*1.5e6)

%voltage divider
R1=200
R2=100
Vd=R1/(R1+R2)*3.3