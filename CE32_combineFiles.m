[f,p]=uigetfile('*.dat');
[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread([p f]);
LFP=readmulti_frank([p f(1:end-4) '_aux.lfp'],8,2:4,0,inf);
LFP=[LFP ;LFP(end,:)];
ratio=fs/1250;
%%
fh=fopen([p f(1:end-4) '_merged.dat'],'w+');
cnt=0;
write_len=2^18;
temp_LFP=zeros(write_len/ratio,size(LFP,2));
while(cnt<Nsamples)
    write_len_this=Nsamples-cnt;
    write_len_this(write_len_this>write_len)=write_len;
    temp_data=readmulti_frank([p f],Nch,1:Nch,cnt,cnt+write_len_this);
    LFP_len=size(LFP,1)-1+(cnt+write_len_this)/ratio;
    temp_LFP= resample(LFP(1+cnt/ratio:1+(cnt+write_len_this)/ratio,:),fs,1250);
    temp=[temp_data temp_LFP(1:length(temp_data),:)];
    fwrite(fh,temp','int16');
    cnt=cnt+write_len_this;
end
fclose(fh);

