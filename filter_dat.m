[f_all,p]=uigetfile('*.lfp','multiselect','on');
if(~iscell(f_all))
    f_all={f_all};
end

[b,a]=butter(2,1/1250*2,'high');
for f_idx=1:length(f_all)
    f=f_all{f_idx};
    [Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread([p f]);
    ratio=fs/1250;
%     data_res=zeros(Nsamples/ratio+1,Nch);
    data_temp_cell=cell(Nch,1);
    parfor idx=1:Nch
        disp(['Processing... File:' num2str(f_idx) '/' num2str(length(f_all)) ' Channel:' num2str(idx) '/' num2str(Nch)]);
        data=readmulti_frank([p f],Nch,idx,0,inf);
        data_temp_cell{idx}=filter(b,a,data);
    end
    data_res=cell2mat(data_temp_cell');
    WriteDat([p f(1:end-4) '_HPF.lfp'],data_res');
end

