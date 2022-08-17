%DAT_plot ERP
convert_eff=0.195;
win=5;
[f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files'},'MultiSelect','Off');
[Nch,fs,Nsamples,~,good_ch,time_bin]=DAT_xmlread([p f]);
[fe,pe]=uigetfile('*.evt');
evt=LoadEvents([pe fe]);
evt_type=unique(evt.description);
s=listdlg('PromptString','Select event type:',...
                'SelectionMode','single',...
                'ListString',evt_type);
evt_selected=evt_type(s);
evt_time=round(evt.time(strcmp(evt_selected,evt.description))*fs);

evt_time(evt_time<win*fs & (evt_time+win*fs)>Nsamples)=[];
%% data handling

LFP=arrayfun(@(x) readmulti_frank([p f],Nch,1:Nch,x-win*fs,x+win*fs),evt_time,'UniformOutput',0);

%% plotting
figure('Name',['ERP of ' f]);
t=(-win*fs:win*fs)/fs;
DTP=squeeze(median(cat(3,LFP{:}),3));
subplot(1,2,1)
r=max(max(DTP))-min(min(DTP))*0.5;
offset=r*(0:Nch-1);
plot(t,bsxfun(@plus,DTP,offset),'b');
axis ij;
axis tight;
ylim([min(offset)-0.5*r max(offset)+0.5*r])
set(gca,'ytick',offset);
set(gca,'yticklabel',num2str((1:Nch)'));
title('ERP')

subplot(1,2,2)
DTP=zscore(DTP,[],1);
r=max(max(DTP))-min(min(DTP))*0.5;
offset=r*(0:Nch-1);
plot(t,bsxfun(@plus,DTP,offset),'b');
axis ij;
axis tight;
ylim([min(offset)-0.5*r max(offset)+0.5*r])
set(gca,'ytick',offset);
set(gca,'yticklabel',num2str((1:Nch)'));
title('Normalized ERP')
