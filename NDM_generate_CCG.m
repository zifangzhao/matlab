%% plot CCG
[f_all,p]=uigetfile('*.res.*','MultiSelect','on');
if ~iscell(f_all)
    temp=f_all;
    f_all=cell(1);
    f_all{1}=temp;
end

for f_idx=1:length(f_all)
    f=f_all{f_idx};
    loc=strfind(f,'.res');
    t_xml=fileread([p f(1:loc-1) '.xml']);
    Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
    Nch=str2num(Nch_str{1});
    fileinfo = dir([p f]);
    fb=fileinfo(1).bytes;
    Nsamples=fb/2/Nch;
    fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
    fs=str2num(fs_str{1});
    % fs=30e3;
    times = LoadSpikeTimes([p f],fs);
    %%
    [clus]=unique(times(:,3));
    Nclu=length(clus);
    % M=round(Nclu^0.5);
    % N=ceil(Nclu^0.5);
    % for idx=1:length(Nclu);
    %     subplot(M,N,idx);
    % [~,clu_id]=sort(clus);
    ch_sel=listdlg('PromptString',['Select units for ' f],'ListString',...
        arrayfun(@(x) num2str(x),clus,'UniformOutput',0),'SelectionMode','multiple','ListSize',[500,500]); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
    idx_sel=ismember(times(:,3),clus(ch_sel));
    figure();
    [~,~,ic]=unique(times(idx_sel,3));
    [ccg,t]=CCG(times(idx_sel,1)*1000,ic,'binSize',1,'duration',100,'mode','ccg');
    PlotCCG(t,ccg);
    xlabel('Time(ms)');
end
% end
