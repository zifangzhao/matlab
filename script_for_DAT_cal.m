%% script for run calculation on DAT structure
freqlist=1:200;
f_group={'*.fls.*','*.tls.*','*.fhs.*','*.ths.*'};
p=[pwd '\'];

wavelet_all=cell(length(f_group),1);
coherence_all=cell(length(f_group),1);
filtered_all=cell(length(f_group),1);
hilbert_power_all=cell(length(f_group),1);
hilbert_phase_all=cell(length(f_group),1);
erp_all=cell(length(f_group),1);
% [f_all,p]=uigetfile('*.*.mat','Select all files need to be calculated','MultiSelect','on');
% if ~iscell(f_all)
%     temp=f_all;
%     f_all=cell(1);
%     f_all{1}=temp;
% end
%%
multiWaitbar('Group',0);
for f_idx=1:length(f_group)
    f=dir(f_group{f_idx});
    f_filtered_all=arrayfun(@(x) x.name,f,'UniformOutput',0);
    cnt=0;
    multiWaitbar('Files',0);
    for idx=1:length(f_filtered_all)
        mo=matfile([p f_filtered_all{idx}],'Writable',true(1));
        DAT=mo.DAT;
        wavelet=DAT_struct_wavelet(DAT,freqlist);
        coherence=DAT_struct_coherence_prepost(DAT);
        filtered=DAT_struct_filter(DAT);
        
        cnt=cnt+length(wavelet);
        w=squeeze(sum(abs(cat(4,wavelet{:})),4)) ;
        c=squeeze(sum(cat(5,coherence.coherence{:}),5));
        f=squeeze(sum(filtered.filtered,4));
        h=squeeze(sum(abs(filtered.hilbert),4));
        ps=squeeze(sum(angle(filtered.hilbert),4));
        erp=squeeze(sum(cat(3,DAT.data{:}),3));
        if idx==1
            wavelet_all{f_idx}=w;
            coherence_all{f_idx}=c;
            filtered_all{f_idx}=f;
            hilbert_power_all{f_idx}=h;
            hilbert_phase_all{f_idx}=ps;
            erp_all{f_idx}=erp;
        else
            wavelet_all{f_idx}=wavelet_all{f_idx}+w;
            coherence_all{f_idx}=coherence_all{f_idx}+c;
            filtered_all{f_idx}=filtered_all{f_idx}+f;
            hilbert_power_all{f_idx}=hilbert_power_all{f_idx}+h;
            hilbert_phase_all{f_idx}=hilbert_phase_all{f_idx}+ps;
            erp_all{f_idx}=erp_all{f_idx}+erp;
        end
        multiWaitbar('Files',idx/length(f_filtered_all));
    end
    wavelet_all{f_idx}=wavelet_all{f_idx}/cnt;
    coherence_all{f_idx}=coherence_all{f_idx}/cnt;
    filtered_all{f_idx}=filtered_all{f_idx}/cnt;
    hilbert_power_all{f_idx}=hilbert_power_all{f_idx}/cnt;
    hilbert_phase_all{f_idx}=hilbert_phase_all{f_idx}/cnt;
    erp_all{f_idx}=erp_all{f_idx}/cnt;
    multiWaitbar('Group',f_idx/length(f_group));
end
bandnames=coherence.Bandnames;
multiWaitbar('Close all');
cd('..');
uisave({'freqlist','DAT','cnt','f_group','coherence_all','wavelet_all','filtered_all','hilbert_power_all','hilbert_phase_all','erp_all','bandnames'},'collected')