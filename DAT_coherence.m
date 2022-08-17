%% DAT cohereogram calculation
[fl,p]=uigetfile({'*.lfp','*.lfp|Select lfp files';'*.dat','*.dat|Select dat files';},'MultiSelect','Off');
t_xml=fileread([p fl(1:end-4) '.xml']);
Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
Nch=str2num(Nch_str{1});
fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
fs=str2num(fs_str{1});
if strcmp(fl(end-2:end),'lfp') %check if target file is lfp file
    fs=1250;
end
cd(p);
[fe,pe]=uigetfile('*.evt','Please select event file');
event=LoadEvents([pe fe]);
evt_type=unique(event.description);
evt_sel=listdlg('PromptString','Select event type','ListString',evt_type,'SelectionMode','single'); %channels to analysis, this is systematic(setup dependent).
evt_time=round(event.time(cellfun(@(x) strcmp(x,evt_type{evt_sel}),event.description))*fs);
win=10; %window length for event calculation in second

ch_sel=listdlg('PromptString','Select channels to run coherence','ListString',arrayfun(@(x) num2str(x),1:Nch,'UniformOutput',0),'SelectionMode','multiple'); %channels to analysis, this is systematic(setup dependent).
ch_sel=inputdlg('Check channel selection','check channel selection',1,{num2str(ch_sel)});
ch_sel=str2num(ch_sel{1});

%%
C=cell(length(evt_time),2);
f_coh=@(x,y) MTCoherogram(x,y,'frequency',fs,'range',[0 200],'window',5);
Bandnames={'custom','theta','delta','spindles','lowGamma','highGamma','ripples'};
t_ruler=[-win*fs:win*fs]';
data=readmulti_frank([p fl],Nch,ch_sel,evt_time(1)-win*fs,evt_time(1)+win*fs);
lfp1=[t_ruler(1:win*fs+1) data(1:win*fs+1,1)];
lfp2=[t_ruler(1:win*fs+1) data(1:win*fs+1,1)];
[C1,t,f]=f_coh(lfp1,lfp2);
f_cohb=@(x,y) median(struct2array(CoherenceBands(MTCoherogram(x,y,'frequency',fs,'range',[0 200],'window',5),f)),1);
Cx=CoherenceBands(C1,f);
%%
for e_idx=1:length(evt_time)
    data=readmulti_frank([p fl],Nch,ch_sel,evt_time(e_idx)-win*fs,evt_time(e_idx)+win*fs);
    C{e_idx,1}=zeros(7,length(ch_sel),length(ch_sel));
    C{e_idx,2}=zeros(7,length(ch_sel),length(ch_sel));
    for c1=1:length(ch_sel)
        for c2=c1+1:length(ch_sel)
            lfp1=[t_ruler(1:win*fs+1) data(1:win*fs+1,c1)];
            lfp2=[t_ruler(1:win*fs+1) data(1:win*fs+1,c2)];
            C1=f_cohb(lfp1,lfp2);
            lfp3=[t_ruler(win*fs+1:end) data(win*fs+1:end,c1)];
            lfp4=[t_ruler(win*fs+1:end) data(win*fs+1:end,c2)];
            C2=f_cohb(lfp3,lfp4);
            C{e_idx,1}(:,c1,c2)=C1;
            C{e_idx,2}(:,c1,c2)=C2;
        end
    end
end

%%
C_pre_avg=median(cat(4,C{:,1}),4);
C_post_avg=median(cat(4,C{:,2}),4);
M=7;
N=3;
cnt=1;
figure()
for idx=1:7
subplot(M,N,cnt);cnt=cnt+1;
imagesc(squeeze(C_pre_avg(idx,:,:)));
set(gca,'Xtick',1:length(ch_sel),'Xticklabel',arrayfun(@num2str,ch_sel,'UniformOutput',0));
set(gca,'Ytick',1:length(ch_sel),'Yticklabel',arrayfun(@num2str,ch_sel,'UniformOutput',0));
title([Bandnames{idx} '\_pre']);
xlabel('channel');ylabel('channel');
caxis([0 1])
colorbar;
subplot(M,N,cnt);cnt=cnt+1;
imagesc(squeeze(C_post_avg(idx,:,:)));
set(gca,'Xtick',1:length(ch_sel),'Xticklabel',arrayfun(@num2str,ch_sel,'UniformOutput',0));
set(gca,'Ytick',1:length(ch_sel),'Yticklabel',arrayfun(@num2str,ch_sel,'UniformOutput',0));
title([Bandnames{idx} '\_post']);
xlabel('channel');ylabel('channel');
caxis([0 1])
colorbar;
subplot(M,N,cnt);cnt=cnt+1;
imagesc(squeeze(C_post_avg(idx,:,:)-C_pre_avg(idx,:,:)));
set(gca,'Xtick',1:length(ch_sel),'Xticklabel',arrayfun(@num2str,ch_sel,'UniformOutput',0));
set(gca,'Ytick',1:length(ch_sel),'Yticklabel',arrayfun(@num2str,ch_sel,'UniformOutput',0));
title([Bandnames{idx} '\_diff']);
xlabel('channel');ylabel('channel');
caxis([-0.1 0.1])
colorbar;
end