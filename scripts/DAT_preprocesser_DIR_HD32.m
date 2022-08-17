%Dat_file_pre_processor_ Dir mode
Nchan=32;
chans=[1:32];
fs=1250;
bulk=100e3;
pth=uigetdir();
cd(pth);
list1=dir();
dir_idx=arrayfun(@(x) list1(x).isdir,1:length(list1));
dir_list=list1(dir_idx);
dir_list(1:2)=[];
% cnt=cell(length(dir_list),1);
for idx=1:length(dir_list)
    p1=dir_list(idx).name;
   
    p2=p1;
    cd(p1);
    f1='amplifier.dat';
    f2='StimulationTime.dat';
%     cnt{idx}=1;
    multiWaitbar('Dir',idx/length(dir_list),'color',[0.5,0.7,0.1]);
    start=0;
    fb=inf;
%     multiWaitbar('closeall')
    fh=fopen([ f2],'w');
    fh2=fopen([ f1(1:end-4) '_med.dat'],'w');
    while start*Nchan*2<fb
        [dat,fb]=readmulti_frank([ f1],Nchan,chans,start,start+bulk-1);
        med=median(dat,2);
        dat=dat-median(dat,2)*ones(1,size(dat,2));
        fwrite(fh,dat','int16');
        multiWaitbar('Progress:',start*Nchan*2/fb)
        start=start+bulk;
    end
    fwrite(fh2,med','int16');
    cd('..')
    fclose(fh);
    fclose(fh2);
end
multiWaitbar('closeall');