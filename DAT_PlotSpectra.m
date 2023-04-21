%%
function [data,t]=DAT_PlotSpectra(filename,figname,fs,flist,Nch,chlist,start,win,gain,res_fs,cutoff,format)
if nargin<9
    gain=0.195;
end
if nargin<10
    res_fs = [];
end
if nargin<11
    cutoff=0.5; %cutoff frequency of HPF
end
if nargin<12
    format='int16';
end
if length(win)==1
    win=win*ones(1,length(start));
end

data=arrayfun(@(x,y) readmulti_frank(filename,Nch,chlist,x*fs,(x+y)*fs,format)*gain,start,win,'uni',0);
if ~isempty(res_fs)
    data= cellfun(@(x) resample(x,res_fs,fs),data,'uni',0);
    fs =res_fs;
end
if length(cutoff)==1
    [b,a]=butter(2,cutoff/fs*2,'high');
elseif length(cutoff)==2
    [b,a]=butter(2,cutoff/fs*2,'bandpass');
end

data=cellfun(@(x) bsxfun(@minus,x,mean(x)),data,'uni',0); %remove DC
data=cellfun(@(x) filtfilt(b,a,x),data,'uni',0);
% data=cellfun(@(x) bsxfun(@minus,x,[1:size(x,2)]*offset),data,'uni',0);
for idx=1:length(data)
    for idy=1:length(chlist)
        subplot(length(chlist),length(data),idx+(idy-1)*length(data))
        t=(1:length(data{idx}))/fs;
        P=abs(awt_freqlist(data{idx}(:,idy),fs,flist,'Gabor'));
        yyaxis left
        imagesc(t,flist,P');
        axis xy;
        title([figname ' T:' num2str(start(idx)) 's CH:' num2str(chlist(idy))],'interpreter','none')
        xlabel('Time(s)');
        ylabel('Frequency (Hz)');
        yyaxis right
        plot(t,data{idx}(:,idy),'w');
       
    end
end
