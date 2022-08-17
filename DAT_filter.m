% resample data and dave to a dat file
% fs=1250;
cnt=1;
clear('elim_channel','band_def');
band_def{cnt}=[0,4];band_name{cnt}='delta';cnt=cnt+1;
band_def{cnt}=[4,10];band_name{cnt}='theta';cnt=cnt+1;
band_def{cnt}=[10,30];band_name{cnt}='beta';cnt=cnt+1;
band_def{cnt}=[30,120];band_name{cnt}='gamma';cnt=cnt+1;
band_def{cnt}=[1 200];band_name{cnt}='low';cnt=cnt+1;
bandsel=listdlg('PromptString','Select bands','ListString',band_name,'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).

% Nch=33;
% ch2fil=1:32;
%% locate original file
[fd p]=uigetfile({'*.lfp','*.lfp|Select lfp files';'*.dat','*.dat|Select dat files';},'MultiSelect','On');
if ~iscell(fd)
    temp=fd;
    fd=cell(1);
    fd={temp};
end
for f_idx=1:length(fd)
    f=fd{f_idx};
    t_xml=fileread([p f(1:end-4) '.xml']);
    Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
    Nch=str2num(Nch_str{1});
    fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
    fs=str2num(fs_str{1});
    if strcmp(f(end-2:end),'lfp') %check if target file is lfp file
        fs=1250;
    end
    if ~exist('elim_channel','var')
        elim_channel=listdlg('PromptString','Select channels to skip','ListString',arrayfun(@(x) num2str(x),1:Nch,'UniformOutput',0),'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
    end
    ch2fil=1:Nch;
    ch2fil=setdiff(ch2fil,elim_channel);
    data=readmulti_frank([p f],Nch,1:Nch,0,inf);
    
    tp_mat=(1:size(data,1))'/fs;
    fil_mat=[tp_mat data(:,ch2fil)];
    
    for idx=bandsel
        BP=band_def{idx};
        %% filtering
        data_fil=FilterLFP(fil_mat,'passband', BP,'nyquist',fs/2);
        data(:,ch2fil)=data_fil(:,2:end);
        f_xml_res=[f(1:end-3) 'xml'];
        f_xml_new=[f(1:end-4) '_' band_name{idx} '.xml'];
        
        if ispc
            system(['copy "' p f_xml_res '" "' p f_xml_new '"']); %copy xml file to dest folder
        else
            system(['cp ''' p f_xml_res ''' ''' p f_xml_new '''']); %copy xml file to dest folder
        end
        %% file writting
        f_out=[p f(1:end-4) '_' band_name{idx} f(end-3:end)];
        fid=fopen(f_out,'w+');
        fwrite(fid,data','int16');
        fclose(fid);
        
        
        
    end
end