[f,p]=uigetfile('*.dat');

data=readmulti_frank([p f],32,9,0,inf);
data_misc=readmulti_frank([p f(1:end-4) '_aux.lfp'],8,5,0,inf);
%%
fs=20000;
fs_lfp=1250;

t1=(1:length(data))/fs;
t2=(1:length(data_misc))/fs_lfp;

t_sel=[110,115];
plot((t_sel(1)*fs:t_sel(2)*fs)/fs,data(t_sel(1)*fs:t_sel(2)*fs));
hold on;
plot((t_sel(1)*fs_lfp:t_sel(2)*fs_lfp)/fs_lfp,data_misc(t_sel(1)*fs_lfp:t_sel(2)*fs_lfp),'r');
hold off;