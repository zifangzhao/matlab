%% Unit phase preference
[f,p]=uigetfile('*.clu.*');
x=importdata([p f]);
f_res=strrep(f,'clu','res');
loc_clu=strfind(f,'.clu');
[Nch,raw_fs,Nsamples,~,good_ch,time_bin]=DAT_xmlread([p f(1:loc_clu) 'dat']);
lfp_fs=1250;
y=round(importdata([p,f_res])/raw_fs*lfp_fs);
% chns=[23 11 5 9 3 12 27 6];
% Nch=33;
clear('band_def','band_name');
cnt=1;
band_def{cnt}=[0,4];band_name{cnt}='delta';cnt=cnt+1;
band_def{cnt}=[4,10];band_name{cnt}='theta';cnt=cnt+1;
band_def{cnt}=[10,30];band_name{cnt}='beta';cnt=cnt+1;
band_def{cnt}=[30,120];band_name{cnt}='gamma';cnt=cnt+1;
band_def{cnt}=[1 200];band_name{cnt}='low';cnt=cnt+1;
bandsel=listdlg('PromptString','Select bands','ListString',band_name,'SelectionMode','single'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).


time_win=5*lfp_fs;
N_bins=30;
%%
[fl,pl]=uigetfile('*.lfp');

%% read xml param

[chns,~] = listdlg('PromptString',[fl ',SEL Channels to compute:' ],...
    'SelectionMode','multiple',...
    'ListString',num2str((1:Nch)'));

data=readmulti_frank([pl fl],Nch,chns,0,inf);
pass_band=band_def{bandsel};
data_fil=Filter([(1:size(data,1))'/lfp_fs data],'passband',pass_band,'nyquist',lfp_fs/2);
data_a=hilbert(data_fil(:,2:end));
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
time_mask_name={'Pre','Post'};
%%
unit_list=unique(x);
M=length(time_mask);
N=round(length(chns));
group_color={'b','r','g','k','c'};
for idx=1:length(unit_list);
    unit_sel=unit_list(idx);
    figure('Name',['Clu:' num2str(unit_sel)]);
    for m_idx=1:length(time_mask)
        for c_idx=1:length(chns)
            chn_sel=chns(c_idx);
            mask=time_mask{m_idx};
            y_in_range=y(mask(y)==1);
            x_in_range=x(mask(y)==1);
            unit_sel_time=y_in_range(x_in_range==unit_sel);
            unit_sel_cplx=data_a(unit_sel_time,c_idx);
            unit_sel_p=data_a_p(unit_sel_time,c_idx);
            unit_sel_a=data_a_a(unit_sel_time,c_idx);
            subplot(M,N,(m_idx-1)*N+c_idx);
            anglehist_frank(unit_sel_cplx,N_bins,group_color{m_idx});
            %             hold on;
            %             arrayfun(@(x) set(x,'color',group_color{m_idx}),h);
            title(['Clu:' num2str(unit_sel) ' Ch:' num2str(chn_sel)]);
        end
    end
end


