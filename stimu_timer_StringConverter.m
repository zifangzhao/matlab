%
function t=stimu_timer_StringConverter(s)
locH=strfind(s,'h');
locM=strfind(s,'m');
locS=strfind(s,'s');
h=str2num(s(1:locH-1));
m=str2num(s(locH+1:locM-1));
s=str2num(s(locM+1:locS-1));
t=h*3600+m*60+s;