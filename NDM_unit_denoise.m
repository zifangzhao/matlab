% NDM noisy spike removal
%%loading file
[fc_all,pc]=uigetfile('*.clu.*','Please select cluster file','MultiSelect','on');
if ~iscell(fc_all)
    temp=fc_all;
    fc_all=cell(1);
    fc_all{1}=temp;
end
loc=strfind(fc_all{1},'.clu');
f_basename=fc_all{1}(1:loc-1);


t_xml=fileread([pc f_basename '.xml']);
Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
Nch=str2num(Nch_str{1});
fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
fs=str2num(fs_str{1});

%load noise time
load([f_basename '_timeselect.mat']);
cd(pc);
%%
for idx=1:length(fc_all)
    fc=fc_all{idx};
    loc=strfind(fc,'.clu');
    clu=importdata([pc fc]);
    spk_time=importdata([pc strrep(fc,'.clu.','.res.')]); %first element is the number of clusters
    spk_Nclu=clu(1);
    spk_clu=clu(2:end);
    spk_time_in_second=1+round(spk_time/fs);
    spk_time_in_second(spk_time_in_second>length(time_bin))=length(time_bin);
    noisy_spikes_idx=time_bin(spk_time_in_second);
    spk_clu(noisy_spikes_idx)=0;
    clu(2:end)=spk_clu;
    newname=[pc fc(1:loc-1) fc(loc:end)];
    dlmwrite(newname,clu);
    
end