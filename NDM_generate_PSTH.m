%script for generating PSTH
%need .res file and .clu file for cluster information 
%need .evt file for event marker

%% Parameter
fs=20e3;
win=[-2 5]; %window of PSTH in second
bin=0.1; %binsize in second

%%loading file
[fc_all,pc]=uigetfile('*.clu.*','Please select cluster file','MultiSelect','on');
cd(pc);
[fe,pe]=uigetfile('*.evt','Please select event file');
if ~iscell(fc_all)
    temp=fc_all;
    fc_all=cell(1);
    fc_all{1}=temp;
end

event=LoadEvents([pe fe]);
evt_type=unique(event.description);
evt_sel=listdlg('PromptString','Select event marker type','ListString',evt_type,'SelectionMode','single'); %channels to analysis, this is systematic(setup dependent).
evt_time=round(event.time(cellfun(@(x) strcmp(x,evt_type{evt_sel}),event.description))*fs);

p_fig=[pc 'fig\'];
system(['mkdir "' p_fig '"']);
%%
for idx=1:length(fc_all)
    fc=fc_all{idx};
    clu=importdata([pc fc]);
    t_offset_max=20;
    spk_time=importdata([pc strrep(fc,'.clu.','.res.')]); %first element is the number of clusters
    spk_Nclu=clu(1);
    spk_clu=clu(2:end);
    
    time_mask=nan(max(spk_time)+t_offset_max*fs,1);
    mask_template=round((win(1)*fs:1:win(2)*fs)/fs/bin)*bin;
    evt_time(evt_time+win(1)*fs<0)=[];
    for idx=1:length(evt_time)
        time_mask(evt_time(idx)+win(1)*fs:evt_time(idx)+win(2)*fs)=mask_template;
    end
    
    
    M=ceil((spk_Nclu)^0.5);
    N=round((spk_Nclu)^0.5);
    spk_list=unique(spk_clu);
    spk_med=arrayfun(@(s_idx) sum(spk_clu==spk_list(s_idx))/max(spk_time)*fs,1:spk_Nclu,'UniformOutput',0);
    t_offset=round(t_offset_max*rand(101,1)*fs);
    t_offset(1)=0;
    [x,y]=meshgrid(1:spk_Nclu,t_offset);
    spk_n=arrayfun(@(s_idx,t) hist(time_mask(t+spk_time(spk_clu==spk_list(s_idx))),win(1):bin:win(2)),x,y,'UniformOutput',0);
    fig_size=[1600 1200];
    h=figure('Name',[fc ' - ' fe '_All'],'Position',[1 1 fig_size]);
    subplot(2,1,1)
    imagesc(win(1):bin:win(2),1:spk_Nclu,cat(1,spk_n{1,:}));
    axis xy;
    set(gca,'Ytick',1:spk_Nclu);
    set(gca,'Yticklabel',num2str(spk_list));
    title('PSTH');
    subplot(2,1,2)
    imagesc(win(1):bin:win(2),1:spk_Nclu,zscore(cat(1,spk_n{1,:}),[],2));
    axis xy;
    set(gca,'Ytick',1:spk_Nclu);
    set(gca,'Yticklabel',num2str(spk_list));
    title('Normalized PSTH');
    
    saveas(h,[p_fig fc ' - ' fe '_All.fig']);
    print(h,[p_fig fc ' - ' fe '_All.jpg'],'-djpeg');
    
    h=figure('Name',[fc ' - ' fe],'Position',[1 1 fig_size]);
    t_FR_delta=2;
    for s_idx=1:spk_Nclu
        subplot(M,N,s_idx)
%         spk_med=sum(spk_clu==spk_list(s_idx))/max(spk_time)*fs;
%         tim_hist=time_mask(spk_time(spk_clu==spk_list(s_idx)));
%         n=hist(tim_hist,win(1):bin:win(2));
        IC=zeros(size(spk_n,1),1);
        for i=1:length(IC)
            spk_count=spk_n{i,s_idx};
            temp=arrayfun(@(idx) mean(spk_count)/spk_count(idx)/length(spk_count)/log2(mean(spk_count)/spk_count(idx)),1:length(spk_count));
            IC(i)=sum(temp(isfinite(temp)));
        end
        ICz=zscore(IC);
        spk_this=spk_time(spk_clu==spk_list(s_idx));
        spk_pre_bin=arrayfun(@(x) sum((spk_this>(x-t_FR_delta*fs))&(spk_this<x)),evt_time);
        spk_post_bin=arrayfun(@(x) sum((spk_this<(x+t_FR_delta*fs))&(spk_this>=x)),evt_time);
        spk_pre_mean=median(spk_pre_bin);
        spk_pre_std=std(spk_pre_bin);
        FR_delta_z=mean((spk_post_bin-spk_pre_mean)/spk_pre_std);
        bar(win(1):bin:win(2),spk_n{1,s_idx}/bin/length(evt_time),1,'EdgeColor','None');
        hold on;
        plot([win(1) win(end)],[spk_med{s_idx} spk_med{s_idx}],'r')
        hold off;
        axis tight
        title(['Clu:' num2str(spk_list(s_idx)) ' FR=' num2str(spk_med{s_idx}) ' FRz=' num2str(FR_delta_z) ' IC=' num2str(IC(1)) ' ICz=' num2str(ICz(1))]);
    end
    saveas(h,[p_fig fc ' - ' fe '_clu.fig']);
    print(h,[p_fig fc ' - ' fe '_clu.jpg'],'-djpeg');
end

