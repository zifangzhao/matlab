%%motion channel mat file generator
Nchn=6;
ch=3;
f=uigetfile('auxiliary.dat');
data=readmulti_frank(f,Nchn,ch,0,inf);
motion=resample(data,1,20000);
clear data
save motion motion