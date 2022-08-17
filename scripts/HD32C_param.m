%script for calculation all the parameters for the HD32 Board
fs=20e3;
%OPA
G=3;
Ib=1e-12;
Vo=0.4e-3;
R_turn=Vo/Ib
Cs=4.5e-12;
Rin=1/(2*pi*Cs*10*fs)