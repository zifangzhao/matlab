% Convert selected ICA back to rawdata
function ica2dat(eeglabmat_filename,dat_filename)
if nargin<1
    [eeglabmat_filename,eeglabmat_path]=uigetfile({'*.mat','*.mat| select matlab file contains eeglab structure'});
end
if nargin<2
    [dat_filename,dat_path]=uigetfile({'*.dat','*.dat| DAT file to be processed';'*.lfp','*.lfp| LFP file to be processed '});
end

%% parameter setting
buffer=10000; % batch  size of data(for each channel)
%% pre-allocate
mo=matfile([eeglabmat_path eeglabmat_filename]);
icaweights=mo.icaweights;
icasphere=mo.icasphere;
icawinv=mo.icawinv;
icachansind=mo.icachansind;
Nch=mo.nbchan;
fs=mo.srate;

elim_icaind=listdlg('PromptString','Select ICAs to delete','ListString',arrayfun(@(x) num2str(x),icachansind,'UniformOutput',0),'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).

%% file preparationica2dat.mica2dat.mica2dat.mica2dat.mica2dat.mica2dat.m
fileinfo = dir([dat_path dat_filename]);
fb=fileinfo(1).bytes;
Nsamples=fb/2/Nch;
fh=fopen([dat_path dat_filename(1:end-4) '_ICA' dat_filename(end-3:end)],'w+');
%% processing data by ica parameters selected
ptr=0;
multiWaitbar('Processing file:',0)
while ptr<Nsamples
    data=readmulti_frank([dat_path dat_filename],Nch,1:Nch,ptr,ptr+buffer-1);
    x=icaweights*icasphere*data(:,icachansind)';
    data(:,icachansind)=x';
    fwrite(fh,data','int16');
    ptr=ptr+buffer;
    multiWaitbar('Processing file:',ptr/Nsamples);
end

multiWaitbar('close all');

fclose(fh);

