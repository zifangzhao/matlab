%% DAT data clipper
[f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files';'*.dat','*.dat|Select dat files';}); %get file need to be clippered
all_evt=dir('*.evt');
evt_names=arrayfun(@(x) x.name,all_evt,'UniformOutput',0);
tf=arrayfun(@(x) sum(strncmpi(f,evt_names,x)),1:length(f),'UniformOutput',1);
loc=find(tf,1,'last');
[f_evt_all,p_evt]=uigetfile(['*.evt'],'multiselect','on');
if ~iscell(f_evt_all)
    temp=f_evt_all;
    f_evt_all=cell(1);
    f_evt_all{1}=temp;
end
[Nch,fs,Nsample,ch_sel]=DAT_xmlread([p f]);

%% input time range
win_str=inputdlg('Input range to be clipped around time points','Range input',1,{'-5 5'});
win=str2num(win_str{1})*fs;

%% select channel
if isempty(ch_sel)
    ch_str=inputdlg('Input channels','ch_sel',1,{['1:' num2str(Nch)]});
    ch_sel=str2num(ch_str{1});
end

%% load unit information
units=NDM_loadunits([p f]);

%% data clipping
for e_idx=1:length(f_evt_all)
    f_evt=f_evt_all{e_idx};
    evt=LoadEvents([p_evt f_evt]);
    if ~isempty(evt.time)
        evt_type=unique(evt.description);
        s=listdlg('PromptString',['Event type for ' f_evt],...
            'SelectionMode','single',...
            'ListString',evt_type,...
            'ListSize',[500,60]);
        evt_selected=evt_type(s);
        evt_time=round(evt.time(strcmp(evt_selected,evt.description))*fs);
        
        DAT.data=arrayfun(@(x) readmulti_frank([p f],Nch,ch_sel,x+win(1),x+win(2)),evt_time,'UniformOutput',0);
        DAT.name=[p f];
        DAT.chsel=ch_sel;
        DAT.fevt=f_evt;
        DAT.evt_time=evt_time;
        DAT.evt_selected=evt_selected;
        DAT.T_win=win;
        DAT.units=units;
        DAT.fs=fs;
        save([p f(1:end-4) f_evt(end-7:end-4) '.mat'],'DAT');
        disp([p f(1:end-4) f_evt(end-7:end-4) '.mat saved'])
%         uisave('DAT',[p f(1:end-4) f_evt(end-8:end-4) '.mat']);
    end
end