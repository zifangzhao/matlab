%impedance comparation
Re=1.5e3;
Ce=1e-9;
freq=logspace(2,6,20);
Ze=Re+1/2/pi/Ce./freq;
%system impedance
Cs=100e-12;
Zs=1/2/pi/Cs./freq;
loglog(freq,Ze);
hold on;
loglog(freq,Zs,'r');
hold off;
legend('Utah Array',['HD32R6 C=' num2str(Cs)])
% ylim([1e3,1e6]);
xlabel('Freq (Hz)')
ylabel('|Z|(ohm)')