%script for adapt the ns exported matfile to EEGLAB
%2012-11-3 created by zifang zhao
[fn,pn]=uigetfile('.mat','Please select the ns exported matfile.');
rawdata=load([pn fn]);
chans=channelpick(fieldnames(rawdata),'elec');
for i = 1:length(chans)
    eval(['rawdata_valid{i} = rawdata.elec' num2str(chans(i)) ';']);
end

data=cell2mat(rawdata_valid)';
% answer=inputdlg({'Dataset name:','Sampling rate(Hz):'},'Parameter for this set',1,...
%     {'Data','1000'});
% cnt=1;
% name=answer{cnt};cnt=cnt+1;
% srate=str2double(answer{cnt});cnt+1;
% EEG=pop_importdata('data','data',...
%     'dataformat','array',...
%     'setname',name,...
%     'nbchan',size(data,1),...
%     'pnts',size(data,2),...
%     'srate',srate);
