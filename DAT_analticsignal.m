%% Extract analytic signal from lfp file
%% parameter setting
passband=[50 80];

%%
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

 ch_sel=listdlg('PromptString','Select channels (base=0)','ListString',arrayfun(@(x) num2str(x),(1:Nch)-1,'UniformOutput',0),'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
ch_sel=ch_sel-1;

 for idx=1:length(ch_sel)
     data=readmulti_frank([p f],Nch,ch_sel(idx)+1,0,inf);
     t=(1:length(data))/fs;
     data_fil = Filter([t' data],'passband',passband,'nyquist',fs/2);
     data_analytic=hilbert(data_fil);
     data_phase=angle(data_analytic(:,2));
     data_power=abs(data_analytic(:,2));
 end