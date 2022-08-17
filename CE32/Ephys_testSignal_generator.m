%Test data generator for CE32 system
pth='G:\My Drive\data\wanlab\mj\Drive2.0\rat4\20170429_laser_170429_191442\';
filename='20170429_laser_170429_191442.lfp';
data=readmulti_frank([pth filename],32,9,0,inf);

%%
filename_signel_ch=[pwd '\' filename(1:end-4) '_single.lfp'];
fh=fopen(filename_signel_ch,'w+');
fwrite(fh,data,'int16');
fclose(fh);

%% generate filtered file
mainFil1=BPF_1250_110_250_DF_float_designer;
data_fil=filter(mainFil1,data);
filename_fil_comp=[pwd '\' filename(1:end-4) '_simMainFil.lfp'];
fh=fopen(filename_fil_comp,'w+');
fwrite(fh,[data data_fil]','int16');
fclose(fh);