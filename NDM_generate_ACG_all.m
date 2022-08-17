%% plot ACG
function NDM_generate_ACG_all(filename)
if isempty(filename)
    [f_all,p]=uigetfile('*.res.*','MultiSelect','on');
else
    f_all=filename;
    p=[];
end

if ~iscell(f_all)
    temp=f_all;
    f_all=cell(1);
    f_all{1}=temp;
end
out_dir=uigetdir(pwd,'Select output folder');
for f_idx=1:length(f_all)
    f=f_all{f_idx};
    loc=strfind(f,'.res');
    clu_id=str2num(f(loc+5:end));
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
    
   ch_sel=find(clus>1);
%     ch_sel=listdlg('PromptString',['Select units for ' f],'ListString',...
%         arrayfun(@(x) num2str(x),clus,'UniformOutput',0),'SelectionMode','multiple','ListSize',[500,500]); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
    h_list=zeros(length(ch_sel),1);
    for u_idx=1:length(ch_sel)
        spk_id=clus(ch_sel(u_idx));
        idx_sel=ismember(times(:,3),spk_id);
        h=figure();
        [~,~,ic]=unique(times(idx_sel,3));
        [ccg,t]=CCG(times(idx_sel,1)*1000,ic,'binSize',1,'duration',100,'mode','ccg');
        PlotCCG(t,ccg);
        xlabel('Time(ms)');
        title(['Clu:' num2str(clu_id) ' Unit:' num2str(spk_id)]); 
        f_out=[out_dir '\' num2str(clu_id) '_' num2str(spk_id) '_ACG'];
        saveas(h,f_out,'eps');
        saveas(h,f_out,'jpg');
        h_list(u_idx)=h;
    end
    arrayfun(@close,h_list);
end
% end
