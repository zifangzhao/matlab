%ANIMAL WATCHER
[filename,pathname]=uigetfile({'*.dat'});
interval=1;

fs=20e3;
Nchan=64;
chan_to_watch=[4:8 36:39];
dat1=[];
while 1
    dat2=readmulti_frank([pathname filename],Nchan,chan_to_watch,-fs*1,0);
    if isequal(dat1,dat2) %system halt warning
        beep;
    end
    dat1=dat2;
    
    if (max(max(dat2)))>=30000 || min(min(dat2))==-30000 || sum(sum(dat2,1)==0) %signal too big too small, flat detection
        beep;
    end
    pause(1)
end