%% noise detect
[fd,p]=uigetfile({'*.lfp','*.lfp|Select lfp files';'*.dat','*.dat|Select dat files';},'MultiSelect','On');
if ~iscell(fd)
    temp=fd;
    fd=cell(1);
    fd{1}=temp;
end
clear('elim_channel');
for f_idx=1:length(fd)
    f=fd{f_idx};
    [Nch,fs,Nsamples,~,good_ch]=DAT_xmlread([p f]);
    if ~exist('elim_channel','var')
        elim_channel=listdlg('PromptString','Select channels to skip','ListString',arrayfun(@(x) num2str(x),1:Nch,'UniformOutput',0),'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
    end
    good_ch=setdiff(good_ch,elim_channel);    
    data=readmulti_frank([p f],Nch,good_ch,0,inf);
    data_mean=mean(data,1);
    data=bsxfun(@minus,data,data_mean);
    
    tp_mat=(1:size(data,1))'/fs;
    fil_mat=[tp_mat data(:,:)];
    data=FilterLFP(fil_mat,'passband',[2 fs/2-1],'nyquist',fs/2);
    data=abs(data);
    data_sum=sum(data,2);
    data_std=mean(data_sum);
    time_bin_raw=data_sum>10*data_std;
    
    win=-2*fs:2*fs;
    noise_pts=find(diff([0 ;time_bin_raw]~=0));
    for idx=1:length(noise_pts)
        locs=noise_pts(idx)+win;
        locs(locs<=0)=[];
        locs(locs>Nsamples)=[];
        time_bin_raw(locs)=1;
    end
    time_bin=~time_bin_raw;
%     %downsampling time_bin to second
%     t_centers=0.5*fs:1*fs:length(time_bin_raw);
%     time_bin=zeros(length(t_centers),1);
%     for idx=1:length(t_centers)
%         x=t_centers(idx);
%         locs=x-0.5*fs+1:x+0.5*fs;
%         locs(locs<=0)=[];
%         locs(locs>Nsamples)=[];
%         time_bin(idx)=sum(time_bin_raw(locs))==0;
%     end
    save([p f(1:end-4) '_timeselect.mat'],'time_bin'); %time_bin==0 means noise period
end
clear('elim_channel');