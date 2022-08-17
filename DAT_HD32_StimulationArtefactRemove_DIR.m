%DAT_file_pre_processor_HD32_DIR
pth=uigetdir(pwd,'Select folder to process(all dat file will be processed,except ''_fixed''&''_stimulation_time'' )');
list1=dir(pth);
dir_idx=arrayfun(@(x) list1(x).isdir,1:length(list1));
dir_list=list1(dir_idx);
dir_list(1:2)=[];
multiWaitbar('Close all')
multiWaitbar('Directory','color',[0.8,0.2,0.2])
multiWaitbar('Files','color',[0.2 0.8 0.3])


    %% filter design
    % All frequency values are in Hz.
    Fs = 1250;  % Sampling Frequency
    
    Fstop = 0.1;         % Stopband Frequency
    Fpass = 0.2;         % Passband Frequency
    Astop = 80;          % Stopband Attenuation (dB)
    Apass = 1;           % Passband Ripple (dB)
    match = 'stopband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
    Hd = design(h, 'butter', 'MatchExactly', match);

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
     sel=sel&arrayfun(@(x) isempty(strfind(x.name,'_DC_remove.dat')),files);
    files=files(sel);
    for f_idx=1:length(files)
        multiWaitbar('Files',f_idx/length(files))
        if ispc
            DAT_HD32_StimulationArtefactRemove([pth '\' dir_list(idx).name '\' files(f_idx).name]);
        else
            DAT_HD32_StimulationArtefactRemove([pth '/' dir_list(idx).name '/' files(f_idx).name]);
        end
    end
end