% DAT noisy spike removal
%%loading file
threshold=5;
win=5; %search win in ms
[fc_all,pc]=uigetfile('*.clu.*','Please select cluster file','MultiSelect','on');
if ~iscell(fc_all)
    temp=fc_all;
    fc_all=cell(1);
    fc_all{1}=temp;
end
loc=strfind(fc_all{1},'.clu');
f_basename=fc_all{1}(1:loc-1);
%make backups
cwd=pwd;
cd(pc);
if ispc
    if(system('mkdir clu')==0);
        system('copy *.clu.* clu');
    end
else
    if(system('mkdir clu')==0);
        system('cp *.clu.* clu');
    end
end
cd(cwd);
[Nch,fs,Nsamples,~,good_ch]=DAT_xmlread([pc f_basename '.dat']);
%load noise time
f_noise=[pc f_basename '_spkCommonMode.dat'];
win_pts=round(win*fs/1000);

fdir_noise=dir(f_noise);
if isempty(fdir_noise)
    DAT_common_mode_extract([pc f_basename '.fil']);
end
dat_noise=abs(readmulti_frank(f_noise,1,1,0,inf));
noise_std=std(dat_noise);
noise_threshold=5*noise_std;
dat_noise=dat_noise>noise_threshold;%change to TF to save memory
dat_noise_df=diff([0 ;dat_noise]);
L=find(dat_noise_df==1);
R=find(dat_noise_df==-1);
for idx=1:length(L)
    L_this=L(idx);
    locs=(L_this-win_pts):L_this;
    locs(locs<=0)=[];
    dat_noise(locs)=1;
end
for idx=1:length(R)
    R_this=R(idx);
    locs=R_this:(win_pts+R_this);
    locs(locs>Nsamples)=[];
    dat_noise(locs)=1;
end
%%
multiWaitbar('Processing clu files:',0);
for idx=1:length(fc_all)
    fc=fc_all{idx};
    loc=strfind(fc,'.clu');
    clu=importdata([pc fc]);
    spk_time=importdata([pc strrep(fc,'.clu.','.res.')]); %first element is the number of clusters
    spk_Nclu=clu(1);
    spk_clu=clu(2:end);
    noisy_spikes_idx=dat_noise(spk_time);
    spk_clu(noisy_spikes_idx)=0;
    clu(2:end)=spk_clu;
    newname=[pc fc(1:loc-1) fc(loc:end)];
    dlmwrite(newname,clu);
    multiWaitbar('Processing clu files:',idx/length(fc_all));
end
multiWaitbar('close all');