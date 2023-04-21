% resample data and dave to a dat file
% locate original file
function DAT_resample(fname,new_fs,fs,Nch)
if nargin < 3
    % [f,p]=uigetfile(fname);
    [Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread(fname);
else
    fileinfo = dir([fname]);
    fb=fileinfo(1).bytes;
    Nsamples = fb/Nch/2;
end

ratio=fs/new_fs;
data_res=int16(zeros(Nsamples/ratio,Nch));

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolsize = 0;
else
    poolsize = poolobj.NumWorkers;
end
if(poolsize==0)
    for idx=1:Nch
        data=readmulti_frank(fname,Nch,idx,0,inf);
        data_res(:,idx)=int16(resample(data,new_fs,fs));
    end
else
    parfor idx=1:Nch
        data=readmulti_frank(fname,Nch,idx,0,inf);
        data_res(:,idx)=int16(resample(data,new_fs,fs));
    end
end
WriteDat([fname(1:end-4) '_resample.dat'],data_res');

