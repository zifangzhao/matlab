%%online lfp generator
function DAT2fil_online(filename)

if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p f];
    cd(p);
end

%Dat_file_pre_processor_ HD32
Nchan=32;
chans=[1:32];
fs=1250;
bulk=round(2*fs);


f1=filename;
start=0;
fb=inf;
fh=fopen([ f1(1:end-4) '.lfp'],'w');
% fh2=fopen([ f1(1:end-4) '_stimulationTime.dat'],'w');

multiWaitbar('File Processing:','color',[0.5 0.7 0.1])
multiWaitbar('File Processing:',0)
if nargin<2
    %% filter design
    % All frequency values are in Hz.
    Fs = fs;  % Sampling Frequency
    
    Fstop = 0.05;         % Stopband Frequency
    Fpass = 0.1;         % Passband Frequency
    Astop = 80;          % Stopband Attenuation (dB)
    Apass = 1;           % Passband Ripple (dB)
    match = 'stopband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
    Hd = design(h, 'butter', 'MatchExactly', match);
    
%% LP filter
    Fs = fs;  % Sampling Frequency
    
    Fpass = 500;         % Passband Frequency
    Fstop = 510;         % Stopband Frequency
    Apass = 1;           % Passband Ripple (dB)
    Astop = 80;          % Stopband Attenuation (dB)
    match = 'stopband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
    Hd1 = design(h, 'butter', 'MatchExactly', match);


end
convert_eff=1/65535*2.5/300*1e6;
stimu_on=[];
%%data process
N=1; %seconds for swap space
filter_swap=zeros(fs*N,Nchan);  %add 2 second filter swap space for the smooth transition between  bulks
a=[];
while 1
    tic
    while 1 %size(a,1)~=bulk
        [a,fb]=readmulti_frank(filename,Nchan,chans,start,start+bulk);
        if size(a,1)==bulk
            break;
        else
            if toc>10
                break;
            end
        end
    end
    if toc>10
        break;
    end
    eliminate_bits=4;
    a1=round(a/2)*2-a;
    a=round(a/(2^eliminate_bits))*(2^eliminate_bits);
    a=a*convert_eff;
    %     stimu_on=a_bin(:,end);
    locs=(sum(a1,2)~=0);
%     stimu_on=[stimu_on;bsxfun(@times,a1(locs,:),start+find(locs))];
    
    %%sos_filtering
    filter_temp=filtfilt(Hd.sosMatrix,Hd.ScaleValues,[filter_swap ;a])/0.195;  %filter and convert to intan scale
%     filter_temp=filtfilt(Hd1.sosMatrix,Hd1.ScaleValues,filter_temp);  %filter and convert to intan scale
%     filter_temp=sosfilt(Hd.sosMatrix,[filter_swap ;a],1)/0.195;  %filter and convert to intan scale
    if (start+bulk)*Nchan*2>=fb
        fwrite(fh,filter_temp(N*fs+1:end,:)','int16');
    else
        filter_swap=a(end-2*N*fs+1:end,:);
        fwrite(fh,filter_temp(N*fs+1:end-N*fs+1,:)','int16');
    end
    if exist('fh2','var')
        fwrite(fh2,stimu_on','int16');
    end
    start=start+bulk;
    multiWaitbar('File Processing:',start*Nchan*2/fb)
end
fclose(fh);
if ~isempty(stimu_on)
    save([ f1(1:end-4) '_stimulationTime'],'stimu_on')
end
