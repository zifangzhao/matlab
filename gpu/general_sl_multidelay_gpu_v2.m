function general_sl_multidelay_gpu_v2(searchkeyword,system_fs,LP,HS,n_rec,p_ref,stps,delays)
% 2012-6-22 revised by zifang zhao save to '-struct' structure
% revised by Zifang Zhao @ 2012-6-21 减去重采样率的输入
% revised by zifang zhao @ 2012-6-19 改变不同频段的采样率
%%created by ZifangZhao @ 2012-6-7

%% 根据关键词查找matfile
matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);

for file_idx=1:length(matfile)
    
    %% load MAT-files
    rawdata=load(matfile(file_idx).name);
    msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
    filename=dir([matfile(file_idx).name(1:end-4) '.xls']);
    if isempty(filename);
        filename=dir([matfile(file_idx).name(1:end-7) '*.xls']);
    end
    filename=filename.name;
    [~,field_names,~]=xlsfinfo(filename);
    if length(field_names)>1
        behavior = importdata(filename);
    else
        eval(['behavior.' field_names{1} '=importdata(filename);']);
    end
    %% channel picking筛选出有效通道
    chans=channelpick(fieldnames(rawdata),'elec');
    
    
    multiWaitbar('Sub classifications:',0,'color',[0.5 1 0.5]);
    multiWaitbar('Frequency bands:',0,'color',[0.8 0.5 0.3]);
    %% 分不同行为进行SL计算
    bhv_name=fieldnames(behavior);
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        for freq_idx=1:length(LP)
            freq=['_L' num2str(LP(freq_idx)) '_H' num2str(HS(freq_idx))];
            fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'sl_' fieldname freq '.mat'];
            %% data_reorganize,降采样
            %取50个数据点时长为1.5个低频周期
            res_fs=ceil(50*LP(freq_idx));
            rawdata_valid=cell(length(chans),1);
            for i = 1:length(chans)
                eval(['rawdata_valid{i} = resample(rawdata.elec' num2str(chans(i)) ',res_fs,system_fs);']);
            end
            if isempty(dir(fname))
                eval(['bhv_time=behavior.' fieldname ';']);
                if(isempty(bhv_time))
                    starts=[];
                    ends=[];
                else
                    starts_ori=bhv_time(:,1);
                    ends_ori=bhv_time(:,2);
                    idx=find(floor((ends_ori-starts_ori)*res_fs)>0);
                    if isempty(idx)
                        starts=[];
                        ends=[];
                    else
                        starts=starts_ori(idx);
                        ends=ends_ori(idx);
                    end
                end
                
                %进行sl计算
                SL=SL_LFP_gpu_v2(rawdata_valid,res_fs,starts,ends,chans,LP(freq_idx),HS(freq_idx),n_rec,p_ref,stps,delays);
                
                %存储数据
                save(fname,'-struct','SL');
                clear('SL')
            end
            clear('rawdata_valid');
            multiWaitbar('Frequency bands:',freq_idx/length(LP),'color',[0.8 0.5 0.3]);
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end