%voltage regulator calculator
%tps79301 VCC
Vtarget=5.3;
Vref=1.2246;
R2=30e3;
R1=R2*(Vtarget/Vref-1);
C=3e-7*(R1+R2)/(R1*R2);


%%TPS72301
Vout=-5;
R2neg=100e3/(Vout/-1.186);
R1neg=100e3-R2neg;

disp(['TPS79301 Vcc= ' num2str(Vtarget ) ' R1=' num2str(R1) ' R2=' num2str(R2) ' C=' num2str(C)]);
disp(['TPS72301 Vss= ' num2str(Vout ) ' R1=' num2str(R1neg) ' R2=' num2str(R2neg)]);