%% Get Cluster infomation from Kwik format HDF5
[f,p]=uigetfile('*.kwik');
filename=[p,f];
time=double(hdf5read(filename, '/channel_groups/0/spikes/time_samples'));
clu=hdf5read(filename, '/channel_groups/0/spikes/clusters/main');
fs=20000;
%% plot ACG
    [clus]=unique(clu);
ch_sel=listdlg('PromptString',['Select units for ' f],'ListString',...
    arrayfun(@(x) num2str(x),clus,'UniformOutput',0),'SelectionMode','multiple','ListSize',[500,500]); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
h_list=zeros(length(ch_sel),1);
mkdir([p f(1:end-5) '_CLU']);
%%
for u_idx=1:length(ch_sel)
    spk_id=clus(ch_sel(u_idx));
    idx_sel=ismember(clu,spk_id);
    h=figure();
    [~,~,ic]=unique(clu(idx_sel));
    [ccg,t]=CCG(time(idx_sel)*1000/fs,ic,'binSize',2,'duration',100,'mode','ccg');
    PlotCCG(t,ccg);
    xlabel('Time(ms)');
    title([' Unit:' num2str(spk_id)]);
%     set(get(gca,'children'),'BarWidth',1);
    f_out=[p f(1:end-5) '_CLU\ACG' num2str(spk_id)];

    saveas(h,f_out,'eps');
    saveas(h,f_out,'jpg');
    h_list(u_idx)=h;
end
% arrayfun(@close,h_list);