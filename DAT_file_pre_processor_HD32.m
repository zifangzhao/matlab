function DAT_file_pre_processor_HD32(filename,Hd)
if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p f];
    cd(p);
end


%Dat_file_pre_processor_ HD32
Nchan=32;
chans=[1:32];
fs=1250;
bulk=fs*100;
gain=300;

f1=filename;
start=0;
fb=inf;
% fh=fopen([ f1(1:end-4) '.lfp'],'w');
% fh2=fopen([ f1(1:end-4) '_stimulationTime.dat'],'w');

multiWaitbar('File Processing:','color',[0.5 0.7 0.1])
multiWaitbar('File Processing:',0)
if nargin<2
    %% filter design
    % All frequency values are in Hz.
    Fs = fs;  % Sampling Frequency
    
    Fstop =0.05;         % Stopband Frequency
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


%     %% bandpass filter
%     Fs = 1250;  % Sampling Frequency
%     
%     Fstop1 =25;         % First Stopband Frequency
%     Fpass1 = 30;         % First Passband Frequency
%     Fpass2 = 80;         % Second Passband Frequency
%     Fstop2 = 85;         % Second Stopband Frequency
%     Astop1 = 60;          % First Stopband Attenuation (dB)
%     Apass  = 1;           % Passband Ripple (dB)
%     Astop2 = 80;          % Second Stopband Attenuation (dB)
%     match  = 'stopband';  % Band to match exactly
%     
%     % Construct an FDESIGN object and call its BUTTER method.
%     h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
%         Astop2, Fs);
%     Hd = design(h, 'butter', 'MatchExactly', match);
% 

end
convert_eff=1/65535*2.5/gain*1e6;
stimu_on=[];
time_limit=inf;%197*60*fs;
%%data process
N=5; %seconds for swap space
[b,a]=butter(5,500/fs,'low');
filter_swap=zeros(fs*N,Nchan);  %add 2 second filter swap space for the smooth transition between  bulks
while start*Nchan*2<fb && start<time_limit
    [a,fb]=readmulti_frank(filename,Nchan,chans,start,start+bulk);
    a=a+32768;
    eliminate_bits=4;
    a1=a-floor(a/2)*2;
    a=floor(a/(2^eliminate_bits))*(2^eliminate_bits);
    a=a-32768;
    a=a*convert_eff/0.195;
    %     stimu_on=a_bin(:,end);
    locs=(sum(a1,2)~=0);
    stimu_on=[stimu_on;bsxfun(@times,a1(locs,:),start+find(locs))];
    
%     %%sos_filtering
%     filter_temp=filtfilt(Hd.sosMatrix,Hd.ScaleValues,[filter_swap ;a]);  %filter and convert to intan scale
% %     filter_temp=filtfilt(Hd1.sosMatrix,Hd1.ScaleValues,filter_temp);  %filter and convert to intan scale
% %     filter_temp=sosfilt(Hd.sosMatrix,[filter_swap ;a],1)/0.195;  %filter and convert to intan scale
%     if (start+bulk)*Nchan*2>=fb
%         fwrite(fh,filter_temp(N*fs+1:end,:)','int16');
%     else
%         filter_swap=a(end-2*N*fs+1:end,:);
%         fwrite(fh,filter_temp(N*fs+1:end-N*fs+1,:)','int16');
%     end
%     if exist('fh2','var')
%         fwrite(fh2,stimu_on','int16');
%     end
    start=start+bulk;
    multiWaitbar('File Processing:',start*Nchan*2/fb)
end
% fclose(fh);
refractory_period=0.05*fs;
if ~isempty(stimu_on)
    save([ f1(1:end-4) '_stimulationTime.mat'],'stimu_on')
    starts_temp=stimu_on(:,11);
    starts_temp=starts_temp(starts_temp~=0);
%     starts=unique(stimu_on(stimu_on~=0));
    start_diff=diff([0 ;starts_temp;0]);
    start_idx=find(start_diff>refractory_period);
    starts=starts_temp(start_idx);
    end_idx=[start_idx(2:end)-1  ;length(starts_temp)];
    end_idx(end_idx<1)=[];
    ends=[starts_temp(end_idx)];
    starts=starts/fs;
    ends=ends/fs;
    events.time=reshape([starts ends]',1,[]);
    events.description=arrayfun(@(x) ['IED start ' ],1:2*length(starts),'UniformOutput',0);
    events.description(2:2:end)=arrayfun(@(x) ['IED stop ' ],1:length(ends),'UniformOutput',0);
    system(['del ' [filename(1:end-4) '.ied.evt']]);
    SaveEvents([filename(1:end-4) '.ied.evt'],events);
end
multiWaitbar('closeall')
disp(['Job done! ' filename ' is processed....'])
