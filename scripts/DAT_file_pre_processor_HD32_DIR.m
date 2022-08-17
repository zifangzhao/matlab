%DAT_file_pre_processor_HD32_DIR or intan
pth=uigetdir(pwd,'Select folder to process(all dat file will be processed,except ''_fixed''&''_stimulation_time'' )');
list1=dir(pth);
dir_idx=arrayfun(@(x) list1(x).isdir,1:length(list1));
dir_list=list1(dir_idx);
dir_list(1:2)=[];
multiWaitbar('Close all')
multiWaitbar('Directory','color',[0.8,0.2,0.2])
multiWaitbar('Files','color',[0.2 0.8 0.3])
multiWaitbar('Directory',0)


%% filter design
% All frequency values are in Hz.
Fs =1250;  % Sampling Frequency

Fstop = 0.05;         % Stopband Frequency
Fpass = 0.1;         % Passband Frequency
Astop = 80;          % Stopband Attenuation (dB)
Apass = 1;           % Passband Ripple (dB)
match = 'stopband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% %% bandpass filter
% Fs = 1250;  % Sampling Frequency
% 
% Fstop1 = 0.1;         % First Stopband Frequency
% Fpass1 = 0.2;         % First Passband Frequency
% Fpass2 = 500;         % Second Passband Frequency
% Fstop2 = 550;         % Second Stopband Frequency
% Astop1 = 60;          % First Stopband Attenuation (dB)
% Apass  = 1;           % Passband Ripple (dB)
% Astop2 = 80;          % Second Stopband Attenuation (dB)
% match  = 'stopband';  % Band to match exactly
% 
% % Construct an FDESIGN object and call its BUTTER method.
% h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
%                       Astop2, Fs);
% Hd = design(h, 'butter', 'MatchExactly', match);


for idx=1:length(dir_list)
    multiWaitbar('Directory',idx/length(dir_list))
    if ispc
        files=dir([pth '\' dir_list(idx).name '\*.dat']);
    else
        files=dir([pth '/' dir_list(idx).name '/*.dat']);
    end
    sel=arrayfun(@(x) isempty(strfind(x.name,'amplifier.dat')),files);
    sel=sel&arrayfun(@(x) isempty(strfind(x.name,'auxiliary.dat')),files);
    sel=sel&arrayfun(@(x) isempty(strfind(x.name,'time.dat')),files);
    sel=sel&arrayfun(@(x) isempty(strfind(x.name,'supply.dat')),files);
    sel=sel&arrayfun(@(x) isempty(strfind(x.name,'_fixed.dat')),files);
    sel=sel&arrayfun(@(x) isempty(strfind(x.name,'_stimulationTime.dat')),files);
    files=files(sel);
    multiWaitbar('Files',0)
    for f_idx=1:length(files)
        multiWaitbar('Files',f_idx/length(files))
        if ispc
            DAT_file_pre_processor_HD32([pth '\' dir_list(idx).name '\' files(f_idx).name]);
        else
            DAT_file_pre_processor_HD32([pth '/' dir_list(idx).name '/' files(f_idx).name]);
        end
    end
end