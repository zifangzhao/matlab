%% ch_sel generation for dat file,text input mode 
[files,p]=uigetfile({'*.lfp','*.lfp| LFP file to be processed';'*.dat','*.dat| DAT file to be processed'},'MultiSelect','on');
if ~iscell(files)
    files={files};
end

for idx=1:length(files)
    f=files{idx};
    [Nch,fs,Nsample]=DAT_xmlread([p f]);
    ch_text=['1:' num2str(Nch)];
    ch_str=inputdlg('Input channels','ch_sel',1,{ch_text});
    ch_text=ch_str{1};
    ch_sel=str2num(ch_str{1});
    save([p f(1:end-4) '_chsel.mat'],'ch_sel')
    disp(['channel selected:' num2str(ch_sel)]);
    disp(['File saved to:' f(1:end-4) '_chsel.mat']);
end