% Convert selected ICA back to rawdata
function ica2raw(eeglabmat_filename,dat_filename)
if nargin<1
    [eeglabmat_filename,eeglabmat_path]=uigetfile({'*ICA.mat','*ICA.mat| select matlab file contains eeglab structure'});
end
if nargin<2
    [dat_filename,dat_path]=uigetfile({'*.lfp','*.lfp| LFP file to be processed ';'*.dat','*.dat| DAT file to be processed'});
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
try
[~,~,~,~,good_ch]=DAT_xmlread([dat_path dat_filename(1:end-4) '_ICA' dat_filename(end-3:end)]);
catch
    [fica,pica]=uigetfile({'*.lfp','*.lfp| LFP ICA file ';'*.dat','*.dat| DAT ICA file'});
    [~,~,~,~,good_ch]=DAT_xmlread([pica fica]);
end
if isempty(good_ch)
    ch_list=1:size(icaweights,1);
else
    ch_list=intersect(good_ch,1:size(icaweights,1));
end 
bad_ch=setdiff(1:size(icaweights,1),good_ch);
elim_icaind=listdlg('PromptString','Select ICAs to delete','ListString',arrayfun(@(x) num2str(x),1:size(icaweights,1),'UniformOutput',0),'initialvalue',bad_ch,'SelectionMode','multiple'); %component to be exclude from ICA analysis, this is systematic(setup dependent).
save([dat_path dat_filename(1:end-4) '_ICAdenoise_elimICs'],'elim_icaind');
%% file preparation
fileinfo = dir([dat_path dat_filename]);
fb=fileinfo(1).bytes;
Nsamples=fb/2/Nch;
fh=fopen([dat_path dat_filename(1:end-4) '_ICAdenoise' dat_filename(end-3:end)],'w+');
%% processing data by ica parameters selected
ptr=0;
if ispc
    system(['copy "' dat_path dat_filename(1:end-4) '.xml" "'  dat_path dat_filename(1:end-4) '_ICAdenoise.xml"']);
else
    system(['cp ''' dat_path dat_filename(1:end-4) '.xml'' '''  dat_path dat_filename(1:end-4) '_ICAdenoise.xml''']);
end
multiWaitbar('Processing file:',0);
while ptr<Nsamples
    data=readmulti_frank([dat_path dat_filename],Nch,1:Nch,ptr,ptr+buffer-1);
    x=icaweights*icasphere*data(:,icachansind)';
    x(elim_icaind,:)=0; %eliminate selected ica
    data(:,icachansind)=(icawinv*x)';
    fwrite(fh,data','int16');
    ptr=ptr+buffer;
    multiWaitbar('Processing file:',ptr/Nsamples);
end

disp(['File outputted to:' [dat_path dat_filename]]);
multiWaitbar('close all');

fclose(fh);

