%merge binary files
[f,p]=uigetfile({'*.lfp','*.lfp|LFP file';'*.dat','*.dat|Binary data file'},'Select file1 to open');
cd(p);
[f1,p1]=uigetfile({'*.lfp','*.lfp|LFP file';'*.dat','*.dat|Binary data file'},'Select file2 to open');
[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread([p f]);
[Nch1,fs1,Nsamples1,ch_sel1,good_ch1,time_bin1]=DAT_xmlread([p1 f1]);

if(isempty(fs))
    x=inputdlg({'Sampling rate','Channel Number'},'Parameter for file1',[1 100]);
    fs=str2num(x{1});
    Nch=str2num(x{2});
end


if(isempty(fs1))
    x1=inputdlg({'Sampling rate','Channel Number'},'Parameter for file2',[1 100]);
    fs1=str2num(x1{1});
    Nch1=str2num(x1{2});
end
%%
if(sum(ismember(f1,{'auxiliary.dat','analogin.dat'})))
    fmt='uint16';
    resampled_data1=arrayfun(@(x) resample(readmulti_frank([p1 f1],Nch1,x,0,inf,fmt),fs,fs1)-32768,1:Nch1,'UniformOutput',0);
else
    fmt='int16';
    resampled_data1=arrayfun(@(x) resample(readmulti_frank([p1 f1],Nch1,x,0,inf,fmt),fs,fs1),1:Nch1,'UniformOutput',0);
end
resampled_data1=cat(2,resampled_data1{:});

%%
fh=fopen([p f(1:end-4) '_merged.' f(end-2:end)],'w+');
bulk=1e5;
st=1;
while(st<Nsamples)
    disp(['Merging:' num2str(st/Nsamples*100) '%'] );
    data=readmulti_frank([p f],Nch,1:Nch,st,st+bulk);
    len=size(data,1);
    data=cat(2,data,resampled_data1(st:st+len-1,:));
    fwrite(fh,data','int16');
    st=st+bulk;
end
fclose(fh);
