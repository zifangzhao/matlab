%Dat_file_pre_processor
Nchan=32;
chans=[1:Nchan];
bulk=100e3;
[f1,p1]=uigetfile('*.dat');
cd(p1);
[f2,p2]=uiputfile('*.dat','Convert save save to',[f1(1:end-4) '_fixed']);
tp_start=fs*60*10;
tp_end=fs*60*60*5;
fb=inf;
multiWaitbar('closeall')
fh=fopen([p2 f2],'w');
% fh2=fopen([p1 f1(1:end-4) '_med.dat'],'w');
while tp_start*Nchan*2<fb && tp_start<tp_end
    [dat,fb]=readmulti_frank([p1 f1],Nchan,chans,tp_start,tp_start+bulk-1);
%     med=median(dat,2);
%     dat=dat-median(dat,2)*ones(1,size(dat,2));
    fwrite(fh,dat','int16');
%     fwrite(fh2,med','int16');
    multiWaitbar('Progress:',tp_start*Nchan*2/fb)
    tp_start=tp_start+bulk;
end
fclose(fh);
% fclose(fh2);
multiWaitbar('closeall');