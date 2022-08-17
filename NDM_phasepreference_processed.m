%% Unit phase preference
%this function should be used when the dat file is already filtered
[f,p]=uigetfile('*.clu.*');
x=importdata([p f]);
f_res=strrep(f,'clu','res');
raw_fs=20000;
lfp_fs=1250;
y=round(importdata([p,f_res])/raw_fs*lfp_fs);
% chns=[23 11 5 9 3 12 27 6];
% Nch=33;
% pass_band=[30 80];
time_win=5*lfp_fs;
N_bins=30;
%%
[fl,pl]=uigetfile('*.lfp');

%% read xml param
t_xml=fileread([p fl(1:end-4) '.xml']);
Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
Nch=str2num(Nch_str{1});
fileinfo = dir([p f]);
fb=fileinfo(1).bytes;
Nsamples=fb/2/Nch;

fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
fs=str2num(fs_str{1});

% [chns,~] = listdlg('PromptString',[fl ',SEL CHNs:' ],...
%     'SelectionMode','multiple',...
%     'ListString',num2str((1:Nch)'));

chns=load([pl fl(1:end-4) '_chsel.mat']);

data_fil=readmulti_frank([pl fl],Nch,chns,0,inf);
% data_fil=Filter([(1:size(data,1))'/lfp_fs data],'passband',pass_band,'nyquist',lfp_fs/2);
data_a=hilbert(data_fil);
data_a_p=abs(data_a);
data_a_a=angle(data_a);
x(1)=[];

%% read event
[fe,pe]=uigetfile('*.evt');
evt=LoadEvents([pe fe]);
evt_type=unique(evt.description);
s=listdlg('PromptString','Select event type:',...
                'SelectionMode','single',...
                'ListString',evt_type);
evt_selected=evt_type(s);
evt_time=round(evt.time(strcmp(evt_selected,evt.description))*lfp_fs);

time_mask=cell(2,1);
mask=zeros(size(data,1),1);
for idx=1:length(evt_time);
    w=evt_time-time_win:evt_time;
    w(w<=0)=[];
    mask(w)=1;
end
time_mask{1}=mask;

mask=zeros(size(data,1),1);
for idx=1:length(evt_time);
    w=evt_time:time_win+evt_time;
    w(w>size(data,1))=[];
    mask(w)=1;
end
time_mask{2}=mask;

%%
unit_list=unique(x);
M=ceil(length(unit_list)^0.5);
N=round(length(unit_list)^0.5);
group_color={'b','r','g','k','c'};

for c_idx=1:length(chns)
    chn_sel=chns(c_idx);
    
    for m_idx=1:length(time_mask)
        mask=time_mask{m_idx};
        y_in_range=y(mask(y)==1);
        x_in_range=x(mask(y)==1);
        figure('Name',['Channel:' num2str(chn_sel)]);
        for idx=1:length(unit_list);
            unit_sel=unit_list(idx);
            unit_sel_time=y_in_range(x_in_range==unit_sel);
            unit_sel_cplx=data_a(unit_sel_time,c_idx);
            unit_sel_p=data_a_p(unit_sel_time,c_idx);
            unit_sel_a=data_a_a(unit_sel_time,c_idx);
            subplot(M,N,idx);
            anglehist_frank(unit_sel_cplx,N_bins,group_color{m_idx});
%             hold on;
%             arrayfun(@(x) set(x,'color',group_color{m_idx}),h);
            title(['Clu:' num2str(unit_sel)]);
        end
    end
end

