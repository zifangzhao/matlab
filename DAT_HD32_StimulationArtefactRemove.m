function DAT_HD32_StimulationArtefactRemove(filename)
if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p f];
    cd(p);
end


%Dat_file_pre_processor_ HD32
Nchan=32;
chans=[1:32];
skip_ch=11;
fs=1250;
gain=300;

[p f]=fileparts(filename);
evt_file=dir([filename(1:end-4) '.ied.evt']);

if isempty(evt_file)
    disp('Stimulation Event File Not Found. Quiting...');
    return
end

evt_time=LoadEvents([p '\' evt_file(1).name]);
stim_start=evt_time.time(1:2:end)*fs;
stim_end=stim_start+0.5*fs;
% stim_end=evt_time.time(2:2:end)*fs;

data=readmulti_frank(filename,Nchan,chans,0,inf);
stim_vec=zeros(length(data),1);

for idx=1:length(stim_start)
    stim_vec(stim_start(idx):stim_end(idx))=1;
end
rst= regexpi(filename,'((?<=Buzsaki)|(?<=buz))\d+','match');
rat_num=str2num(rst{end});
switch(rat_num)
    case 41
        ch=24;
    case 44
        ch=30;
    case 50
        ch=21;
    case 55
        ch=19;
end
ch_to_run=1:32;
[b,a]=butter(2,0.5/fs*2,'high');
rmv_evt_idx=[];
rmv_evt_threshold=fs*0.5; %if saturation is longer than this period, it will get removed
evt_removal_area=zeros(length(data),1);
for idx=1:length(ch_to_run)
    data_this=data(:,ch_to_run(idx));
    saturated_idx=(data_this>=30000)|(data_this<=-30000);
    saturated_idx=imdilate(saturated_idx,strel('line',0.1*fs,90));
    saturated_idx=imerode(saturated_idx,strel('line',0.1*fs,90));
    saturated_idx_diff=diff([0 ;saturated_idx ;0]);
    sat_start=find(saturated_idx_diff==1);
    sat_end=find(saturated_idx_diff==-1)+0.1*fs;
    sat_start(sat_start<=1)=2;
    sat_end(sat_end>length(data_this)-1)=length(data_this)-1;
    stim_sat_idx=arrayfun(@(x) sum(stim_vec(sat_start(x):sat_end(x)))>0,1:length(sat_start));
    sat_start=sat_start(stim_sat_idx);
    sat_end=sat_end(stim_sat_idx);
    offsets=zeros(length(data_this),1);
    for s=1:length(sat_start)
        if((sat_end(s)-sat_start(s))>rmv_evt_threshold)
            evt_removal_area(sat_start(s):sat_end(s))=1;
        end
        sts_range=(sat_start(s)-20):sat_start(s);
        sts_range(sts_range<1)=[];
        end_range=sat_end(s):sat_end(s)+10;
        end_range(end_range>length(data_this))=[];
        start_voltage=median(data_this(sts_range));
        end_voltage=median(data_this(end_range));
        data_this(sat_start(s):sat_end(s))=start_voltage;
        offsets(sat_end(s)+1)=end_voltage-start_voltage;
%         data_this(sat_end(s)+1:end)= data_this(sat_end(s)+1:end)-(end_voltage-start_voltage);
    end
    data(:,ch_to_run(idx))=filtfilt(b,a,data_this-cumsum(offsets));
end

noisy_remove_idx=find(evt_removal_area(round(stim_start)));
evt_time.time([noisy_remove_idx (noisy_remove_idx+1)])=[];
evt_time.description([noisy_remove_idx (noisy_remove_idx+1)])=[];
system(['del ' [filename(1:end-4) '_DC_remove.ied.evt']]);
SaveEvents([filename(1:end-4) '_DC_remove.ied.evt'],evt_time);
    
new_filename=[filename(1:end-4) '_DC_remove_all.dat'];
sav2dat(new_filename,data');
system(['copy ' filename(1:end-4) '.xml ' new_filename(1:end-4) '.xml']);
