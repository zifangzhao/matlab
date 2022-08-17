function dat2lfp_frank(f_all,b,a,format)
%DAT2lfp
sel_file=0;
if (nargin<1)
    sel_file=1;
else
    if(isempty(f_all))
        sel_file=1;
    end
end
if nargin < 4
    format = 'int16';
end
    
if(~iscell(f_all))
    f_all={f_all};
end
if(sel_file==1)
    [f_all,p]=uigetfile('*.dat','multiselect','on');
    if(~iscell(f_all))
        f_all={f_all};
    end
    f_all=cellfun(@(x) [p x],f_all,'UniformOutput',0);
end


if(nargin<3)
    b=[];
    a=[];
end
for f_idx=1:length(f_all)
    f=f_all{f_idx};
    [Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread([f]);
    ratio=fs/1250;
    %     data_res=zeros(Nsamples/ratio+1,Nch);
    data_temp_cell=cell(Nch,1);
    parfor idx=1:Nch
        disp(['Processing... File:' num2str(f_idx) '/' num2str(length(f_all)) ' Channel:' num2str(idx) '/' num2str(Nch)]);
        data=readmulti_frank([f],Nch,idx,0,inf,format);
        data_temp_cell{idx}=resample(data,1250,fs);
        if(~isempty(b))
            data_temp_cell{idx}=filtfilt(b,a,data_temp_cell{idx});
        end
    end
    data_res=cell2mat(data_temp_cell');
    WriteDat([f(1:end-4) '.lfp'],data_res');
end

