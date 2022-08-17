function DAT_file_pre_processor_Intan(filename,res_fs,Hd,chans,overlapMode)
if nargin<1||isempty(filename)
    [f,p]=uigetfile('*.dat');
    filename=[p f];
    cd(p);
end

if nargin<5
    overlapMode=2;
end

%% find xml and read informations
if ispc
    loc=strfind(filename,'\');
    pth=filename(1:loc(end));
else
    loc=strfind(filename,'/');
    pth=filename(1:loc(end));
end
xml=dir([filename(1:end-4) '.xml']);
if isempty(xml)
    msgbox(['xml for file:' filename ' Not found!'],'replace');
    [f,p]=uigetfile('*.xml');
    xml=f;
    if isempty(xml)
        return;
    end
else
    xml=xml(1).name;
end

% read xml
xDoc=xmlread([pth xml]);
allList=xDoc.getElementsByTagName('acquisitionSystem');
acqparams=allList.item(0);
Nchanitemlist=acqparams.getElementsByTagName('nChannels');
Nchanitem=Nchanitemlist.item(0);
Fsitemlist=acqparams.getElementsByTagName('samplingRate');
Fsitem=Fsitemlist.item(0);

Nchan=str2double(char(Nchanitem.getFirstChild.getData));
% chans=1:Nchan;
fs=str2double(char(Fsitem.getFirstChild.getData));
bulk=100e3;

if nargin<4
    chans=1:Nchan;
end

f1=filename;
start=0;
fb=inf;
if ~isempty(res_fs)
    if isempty(dir([ f1(1:end-4) '.lfp']))
        fh=fopen([ f1(1:end-4) '.lfp'],'w');
    else
        switch overlapMode
            case 2
                choice=questdlg('Found old file,overlap?','Warning','Yes','No','Yes');
                switch choice
                    case 'Yes'
                        fh=fopen([ f1(1:end-4) '.lfp'],'w');
                    case 'No'
                        return;
                end
            case 1
                fh=fopen([ f1(1:end-4) '.lfp'],'w');
            case 0
                return;
        end
    end
else
    if isempty([ f1(1:end-4) '_fixed.dat'])
        fh=fopen([ f1(1:end-4) '_fixed.dat'],'w');
    else
        switch overlapMode
            case 2
                choice=questdlg('Found old file,overlap?','Warning','Yes','No','Yes');
                switch choice
                    case 'Yes'
                        fh=fopen([ f1(1:end-4) '_fixed.dat'],'w');
                    case 'No'
                        return;
                end
            case 1
                fh=fopen([ f1(1:end-4) '_fixed.dat'],'w');
            case 0
                return;
        end
    end
end
% fh2=fopen([ f1(1:end-4) '_stimulationTime.dat'],'w');

multiWaitbar(['File Processing:' filename],'color',[0.5 0.7 0.1])
multiWaitbar(['File Processing:' filename],0)
msgbox(['Processing: ' filename],'replace');
if nargin<3
    %% filter design
    All frequency values are in Hz.
    Fs = fs;  % Sampling Frequency
    
    Fstop = 0.1;         % Stopband Frequency
    Fpass = 0.2;         % Passband Frequency
    Astop =1250;          % Stopband Attenuation (dB)
    Apass = 1;           % Passband Ripple (dB)
    match = 'stopband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
%     Hd = design(h, 'butter', 'MatchExactly', match);

%    %% LP filter
%     Fs = fs;  % Sampling Frequency
%     
%     Fpass = 500;         % Passband Frequency
%     Fstop = 550;         % Stopband Frequency
%     Apass = 1;           % Passband Ripple (dB)
%     Astop = 80;          % Stopband Attenuation (dB)
%     match = 'stopband';  % Band to match exactly
%     
%     % Construct an FDESIGN object and call its BUTTER method.
%     h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
%     Hd1 = design(h, 'butter', 'MatchExactly', match);


%     %% bandpass filter
%     Fs = 1250;  % Sampling Frequency
%     
%     Fstop1 = 0.1;         % First Stopband Frequency
%     Fpass1 = 0.5;         % First Passband Frequency
%     Fpass2 = 500;         % Second Passband Frequency
%     Fstop2 = 550;         % Second Stopband Frequency
%     Astop1 = 60;          % First Stopband Attenuation (dB)
%     Apass  = 1;           % Passband Ripple (dB)
%     Astop2 = 80;          % Second Stopband Attenuation (dB)
%     match  = 'stopband';  % Band to match exactly
%     
%     % Construct an FDESIGN object and call its BUTTER method.
%     h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
%         Astop2, Fs);
%     Hd = design(h, 'butter', 'MatchExactly', match);


end


%%data process
N=1; %seconds for swap space
filter_swap=zeros(fs*N,length(chans));  %add 2 second filter swap space for the smooth transition between  bulks

while start*Nchan*2<fb
    [a,fb]=readmulti_frank(filename,Nchan,chans,start,start+bulk-1);
    
    if ~isempty(Hd)
        filter_temp=filtfilt(Hd.sosMatrix,Hd.ScaleValues,[filter_swap ;a])/0.195;  %filter and convert to intan scale
    end
    if exist('Hd1')
        filter_temp=filtfilt(Hd1.sosMatrix,Hd1.ScaleValues,filter_temp);  %filter and convert to intan scale
    end
    if isempty(Hd)&&~exist('Hd1')
        filter_temp=[filter_swap ;a];
    end
    %     filter_temp=sosfilt(Hd.sosMatrix,[filter_swap ;a],1)/0.195;  %filter and convert to intan scale
    if (start+bulk)*Nchan*2>=fb
        data_to_w=filter_temp(N*fs+1:end,:);
    else
        filter_swap=a(end-2*N*fs+1:end,:);
        data_to_w=filter_temp(N*fs+1:end-N*fs+1,:);
    end
    if ~isempty(res_fs)
        data_to_w=resample(data_to_w,res_fs,fs);
    end
    fwrite(fh,data_to_w','int16');
%     fwrite(fh2,stimu_on','int16');
    start=start+bulk;
    multiWaitbar(['File Processing:' filename],start*Nchan*2/fb)
end
multiWaitbar(['File Processing:' filename],'Close')
fclose(fh);

