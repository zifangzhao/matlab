function DAT_file_pre_processor_HD64_fixAlign(filename)
if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p f];
    cd(p);
end


%Dat_file_pre_processor_ HD32
Nchan=64;
chans=[1:64];
fs=5000;
bulk=fs*100;
gain=300;

f1=filename;
start=0;
fb=inf;
fh=fopen([ f1(1:end-4) '_fix.dat'],'w');
% fh2=fopen([ f1(1:end-4) '_stimulationTime.dat'],'w');

multiWaitbar('File Processing:','color',[0.5 0.7 0.1])
multiWaitbar('File Processing:',0)


% convert_eff=1/65535*2.5/gain*1e6;
stimu_on=[];
time_limit=inf;%197*60*fs;
%%data process
N=5; %seconds for swap space
[b,a]=butter(5,500/fs,'low');
filter_swap=zeros(fs*N,Nchan);  %add 2 second filter swap space for the smooth transition between  bulks
while start*Nchan*2<fb && start<time_limit
    [a,fb]=readmulti_frank(filename,Nchan,chans,start,start+bulk);
    a(1:32,:)=a(1:32,:)*2;
    filter_temp=a+32768;
    filter_temp(filter_temp>=32768)=filter_temp(filter_temp>=32768)-65536;
%     %%sos_filtering
%     filter_temp=filtfilt(Hd.sosMatrix,Hd.ScaleValues,[filter_swap ;a]);  %filter and convert to intan scale
% %     filter_temp=filtfilt(Hd1.sosMatrix,Hd1.ScaleValues,filter_temp);  %filter and convert to intan scale
% %     filter_temp=sosfilt(Hd.sosMatrix,[filter_swap ;a],1)/0.195;  %filter and convert to intan scale
    if (start+bulk)*Nchan*2>=fb
        fwrite(fh,filter_temp','int16');
    else
%         filter_swap=a(end-2*N*fs+1:end,:);
        fwrite(fh,filter_temp','int16');
    end
%     if exist('fh2','var')
%         fwrite(fh2,stimu_on','int16');
%     end
    start=start+bulk;
    multiWaitbar('File Processing:',start*Nchan*2/fb)
end
% fclose(fh);
if ~isempty(stimu_on)
    save([ f1(1:end-4) '_stimulationTime.mat'],'stimu_on')
    starts=unique(stimu_on(stimu_on~=0));
    mid=starts+1;
    ends=mid+1;
    starts=starts/fs;
    mid=mid/fs;
    ends=ends/fs;
    events.time=reshape([starts ;mid;ends],1,[]);
    events.description=arrayfun(@(x) ['IED start ' ],1:3*length(starts),'UniformOutput',0);
    events.description(2:3:end)=arrayfun(@(x) ['IED peak ' ],1:length(ends),'UniformOutput',0);
    events.description(3:3:end)=arrayfun(@(x) ['IED stop ' ],1:length(ends),'UniformOutput',0);
    system(['del ' [filename(1:end-4) '.ied.evt']]);
    SaveEvents([filename(1:end-4) '.ied.evt'],events);
end
multiWaitbar('closeall')
disp(['Job done! ' filename ' is processed....'])
