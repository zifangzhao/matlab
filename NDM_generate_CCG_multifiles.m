%% plot CCG
[f_all,p]=uigetfile('*.res.*','MultiSelect','on');
if ~iscell(f_all)
    temp=f_all;
    f_all=cell(1);
    f_all{1}=temp;
end

t_all=cell(length(f_all),1);
ic_all=cell(length(f_all),1);
name_all=cell(length(f_all),1);
N=0;
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
    [~,~,ic]=unique(times(idx_sel,3));
    
    ic_all{f_idx}=ic+N;
    if(isfinite(max(ic)))
        N=N+max(ic);
    end
    t_all{f_idx}=times(idx_sel,1)*1000;
    name_all{f_idx}=arrayfun(@(x) [num2str(f_idx) '-' num2str(x)],ch_sel,'UniformOutput',0);
end
%%
figure();
t_combined=cat(1,t_all{:});
ic_combined=cat(1,ic_all{:});
name_combined=cat(2,name_all{:});
[ccg,t]=CCG(t_combined,ic_combined,'binSize',1,'duration',100,'mode','ccg');
PlotCCG(t,ccg);
%
N=max(ic_combined);
for m=1:N
    for n=1:m
        subplot(N,N,n+(N-m)*N);
        title([name_combined{n} ':' name_combined{m}],'FontSize', 8)
    end
end
xlabel('Time(ms)');

