%% selected_channel_list generation for dat file
[files,p]=uigetfile('*.dat','Select files to be processed','MultiSelect','on');
if ~iscell(files)
    files={files};
end
ch_sel_string=inputdlg('Input selected channels');
ch_sel_cell=regexpi(ch_sel_string,'\d+','match');
ch_sel=cellfun(@str2num,ch_sel_cell{1});
for idx=1:length(files)
    f=files{idx};
    save([p f(1:end-4) '_chsel.mat'],'ch_sel')
end