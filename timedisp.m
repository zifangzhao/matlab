%% disp in hh/mm/ss
function [hh mm ss]=timedisp(time)
hh=int32(time/3600);
a=mod(time,3600);
mm=int32(a/60);
b=mod(a,60);
ss=b;