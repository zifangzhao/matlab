% HD32_gain
Ce=150e-12; %elec capacitance
Cs=linspace(1e-12,1000e-12,100);
Cd=(12*2+2.1+3)*10^-12; %drain side capacitance
G1=Ce./(Ce+Cs);
G2=(Cs./(Cs+Cd));
figure();
plot(Cs,G1)
xlabel('Cs pC')
ylabel('Gain')
hold on
plot(Cs,G2,'r')
plot(Cs,G1.*G2,'b')
xlabel('Cs pC')
ylabel('Gain')
hold off;

%% cross talk
plot(Cs*1e9,20*log10(Cd./Cs))
xlabel('C_S(nF)')
ylabel('Crosstalk (dB)')
title('Crosstalk vs C_S')