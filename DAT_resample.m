% resample data and dave to a dat file
% locate original file
function DAT_resample(fname,new_fs)
% [f,p]=uigetfile(fname);
[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread(fname);
ratio=fs/new_fs;
data_res=zeros(Nsamples/ratio,Nch);
parfor idx=1:Nch
    data=readmulti_frank(fname,Nch,idx,0,inf);
    data_res(:,idx)=resample(data,new_fs,fs);
end
WriteDat([fname(1:end-4) '_resample.dat'],data_res');

