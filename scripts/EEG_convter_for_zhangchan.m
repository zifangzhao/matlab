%script for  adaptthe EEG exported matfile to EEGLAB
%2012-12-2 created by zifang zhao
[fn,pn]=uigetfile('.mat','Please select the EEG matfile.');
rawdata=load([pn fn]);
fname=fieldnames(rawdata);
idx=find(~cellfun(@isempty,(strfind(fname,'smp'))));
data=getfield(rawdata,fname{idx});