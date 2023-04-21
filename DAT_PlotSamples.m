function [data,t]=DAT_PlotSamples(filename,figname,fs,Nch,chlist,start,win,gain,offset,cutoff,datatype)
if nargin<8
    gain=0.195;
end
if nargin<9
    offset=1000;
end
if nargin<10
    cutoff=[]; %cutoff frequency of HPF
end
if nargin<11
    datatype='int16';
end
if length(win)==1
    win=win*ones(1,length(start));
end

if length(cutoff)==0
    b=[];a=[];
end
if length(cutoff)==1
    [b,a]=butter(2,cutoff/fs*2,'high');
end
if length(cutoff)==2
    [b,a]=butter(2,cutoff/fs*2,'bandpass');
end

data=arrayfun(@(x,y) readmulti_frank(filename,Nch,chlist,x*fs,(x+y)*fs,datatype)*gain,start,win,'uni',0);
data=cellfun(@(x) bsxfun(@minus,x,mean(x)),data,'uni',0); %remove DC
if(~isempty(b))
    data=cellfun(@(x) filtfilt(b,a,x),data,'uni',0);
end
data=cellfun(@(x) bsxfun(@minus,x,[1:size(x,2)]*offset),data,'uni',0);
for idx=1:length(data)
    subplot(length(data),1,idx)
    t=(1:length(data{idx}))/fs;
    plot(t,data{idx},'k');
    axis tight
    title([figname ' T:' num2str(start(idx)) 's'],'interpreter','none')
end