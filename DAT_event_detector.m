%% This script is used to detect specific neural event from LFP file
%% parameter setting
threshould=[2 5];
passband=[50 80];
duration=[30 300 60];
[f,p]= uigetfile({'*.lfp','*.lfp| LFP file to be processed';'*.dat','*.dat| DAT file to be processed'});
t_xml=fileread([p f(1:end-4) '.xml']);
Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
Nch=str2num(Nch_str{1});
fileinfo = dir([p f]);
fb=fileinfo(1).bytes;
Nsamples=fb/2/Nch;
if strcmp(f(end-2:end),'lfp')
    fs=1250;
else
    fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
    fs=str2num(fs_str{1});
end

 ch_sel=listdlg('PromptString','Select channels to detect','ListString',arrayfun(@(x) num2str(x),1:Nch,'UniformOutput',0),'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).

 for idx=1:length(ch_sel)
     data=readmulti_frank([p f],Nch,ch_sel(idx),0,inf);
     data_fil = Filter(data,'passband',passband,varargin{:});

     [gamma,sd,bad] = FindRipples(fil_sleep,'thresholds',threshould, 'durations', duration); 
     
     gamma_file = strcat(fbasename, num2str(ch_sel(idx)-1), 'gamma');
     save (gamma_file, 'gamma')
     spindle_events = strcat(fbasename, num2str(ch_sel(idx)-1), '.gam.evt');
     SaveRippleEvents(spindle_events,gamma,ch_sel(idx)-1);

