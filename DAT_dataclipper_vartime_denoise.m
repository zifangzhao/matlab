%% DAT data clipper
[f,p]=uigetfile({'*denoise*.lfp','*.lfp|Select lfp files';'*denoise*.dat','*.dat|Select dat files';}); %get file need to be clippered
all_evt=dir('*.evt');
evt_names=arrayfun(@(x) x.name,all_evt,'UniformOutput',0);
tf=arrayfun(@(x) sum(strncmpi(f,evt_names,x)),1:length(f),'UniformOutput',1);
loc=find(tf,1,'last');
[f_evt_all,p_evt]=uigetfile([f(1:loc) '*.evt'],'multiselect','on');
if ~iscell(f_evt_all)
    temp=f_evt_all;
    f_evt_all=cell(1);
    f_evt_all{1}=temp;
end
[Nch,fs,Nsample,ch_sel,good_ch,time_bin]=DAT_xmlread([p f]);

%% input time range
% win_str=inputdlg('Input range to be clipped around time points','Range input',1,{'-5 5'});
% win=str2num(win_str{1})*fs;

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
        evt_selected1=evt_type(find(cellfun(@(x) ~isempty(x),strfind(evt_type,'start'))));
        evt_selected2=evt_type(find(cellfun(@(x) ~isempty(x),strfind(evt_type,'end'))));
        if isempty(evt_selected2)
            evt_selected2=evt_type(find(cellfun(@(x) ~isempty(x),strfind(evt_type,'stop'))));
        end
        evt_time=[round(evt.time(strcmp(evt_selected1,evt.description))*fs) round(evt.time(strcmp(evt_selected2,evt.description))*fs)];
        DAT.data=cell(size(evt_time,1),1);
        for t_idx=1:size(evt_time,1)
            time_temp=evt_time(t_idx,1):evt_time(t_idx,2);
            data_temp=readmulti_frank([p f],Nch,ch_sel,evt_time(t_idx,1),evt_time(t_idx,2));
            time_sel=time_bin(time_temp);
            DAT.data{t_idx}=data_temp(time_sel,:); %noise removal
        end
        DAT.name=[p f];
        DAT.chsel=ch_sel;
        DAT.fevt=f_evt;
        DAT.evt_time=evt_time;
        DAT.evt_selected={evt_selected1;evt_selected2};
%         DAT.T_win=win;
        DAT.units=units;
        DAT.fs=fs;
        save([p f(1:end-4) f_evt(end-7:end-4) '.mat'],'DAT');
        disp([p f(1:end-4) f_evt(end-7:end-4) '.mat saved'])
%         uisave('DAT',[p f(1:end-4) f_evt(end-8:end-4) '.mat']);
    end
end