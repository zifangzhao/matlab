%% selected_channel_list generation for dat file
[files,p]=uigetfile({'*.lfp','*.lfp| LFP file to be processed';'*.dat','*.dat| DAT file to be processed'},'MultiSelect','on');
if ~iscell(files)
    files={files};
end
for idx=1:length(files)
    f=files{idx};
    t_xml=fileread([p f(1:end-4) '.xml']);
    good_ch=sort(cellfun(@str2num,(regexpi(t_xml,'(?<=<channel skip="0">)\d+(?=<)','match'))))+1;
    
    s=1;
    ch_sel=[];
    while ~isempty(s);
        chnleft=setdiff(good_ch,ch_sel)';
        [s,~] = listdlg('PromptString',[f ',SEL CHNs:' num2str(ch_sel)],...
            'SelectionMode','single',...
            'ListSize',[500 500],...
            'ListString',num2str(chnleft));
        ch_sel=[ch_sel chnleft(s)];
    end
    save([p f(1:end-4) '_chsel.mat'],'ch_sel')
end