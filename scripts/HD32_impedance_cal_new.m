R_elec=1.5e6;
C_elec=3e-9;
freq_test=logspace(2,5,100);
figure(1)
Zelec=1./(1/R_elec+2*pi*C_elec.*freq_test);
loglog(freq_test,Zelec);
xlabel('Frequency');
ylabel('Impedance|Z|');
title(['Simulated Electrode Impedance' 'Z(1KHz)=' num2str(1./(1/R_elec+2*pi*C_elec.*1000))]);
freq=1000;
C_e=13e-12;
C_s=linspace(1e-12,1e-9,100);
G_imp=zeros(length(C_s),length(freq));
G_mux=zeros(length(C_s),length(freq));
G_all=zeros(length(C_s),length(freq));
for y=1:length(freq)
    Z_elec=1/(1/R_elec+2*pi*C_elec.*freq);
    for x=1:length(C_s)
        Z_s=1/2/pi/C_s(x)/freq;
        Z_e=1/2/pi/C_e/freq;
        G_imp(x,y)=Z_s/(Z_s+Z_elec);
        G_mux(x,y)=Z_e/(Z_s+Z_e);
        G_all(x,y)=G_imp(x,y)*G_mux(x,y);
    end
end

%%
figure(2)
plot(C_s*1e12,G_imp,'c')
hold on;
plot(C_s*1e12,G_mux,'r')
plot(C_s*1e12,G_all,'b')
hold off;


%%
% figure(3);
% plot(*
