function general_sl_multidelay(searchkeyword,system_fs,LP,HS,n_rec,p_ref,stps,delays,max_steps,n_level)
% revised by zifang zhao @ 2012-4-17    修正对excel格式以及单行时间点的支持
% revised by zifang zhao @ 2012-12-27 修正.startpoint的范围
% revised by zifang zhao @ 2012-12-22 修正对stp为负数时的数据截取
% revised by zifang zhao @ 2012-12-20 增加输入level,用于噪音筛除电平(abs)
% revised by zifang zhao @ 2012-12-12 修正多个文件共用同一个源文件时的读取问题
% revised by zifang zhao @ 2012-12-9 优化临时文件命名，支持同一文件夹多个文件同时计算
% revised by zifang zhao @ 2012-12-5 增加max_steps，优化计算点数
% revised by zifang zhao @ 2012-10-17 修正快速继续
% revised by zifang zhao @ 2012-9-12 采样率不整数化
% revised by zifang zhao @ 2012-9-10 更改采样率为3倍HS
% revised by zifang zhao @ 2012-9-5 分析时间改为毫秒为单位
% 2012-6-22 revised by zifang zhao save to '-struct' structure
% revised by Zifang Zhao @ 2012-6-21 减去重采样率的输入
% revised by zifang zhao @ 2012-6-19 改变不同频段的采样率
%%created by ZifangZhao @ 2012-6-7

%% 根据关键词查找matfile
matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);

for file_idx=1:length(matfile)
    
    %% load MAT-files

    msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
    filename=dir([matfile(file_idx).name(1:end-4) '.xls']);
    if isempty(filename);
        filename=dir([matfile(file_idx).name(1:end-7) '*.xls']);
    end
    if isempty(filename);
        filename=dir([matfile(file_idx).name(1:end-4) '*.xlsx']);
    end
    if isempty(filename);
        filename=dir([matfile(file_idx).name(1:end-7) '*.xlsx']);
    end
    filename=filename.name;
    [~,field_names,~]=xlsfinfo(filename);
    if length(field_names)>1
        behavior = importdata(filename);
    else
        eval(['behavior.' field_names{1} '=importdata(filename);']);
    end

    
    
    multiWaitbar('Sub classifications:',0,'color',[0.5 1 0.5]);
    multiWaitbar('Frequency bands:',0,'color',[0.8 0.5 0.3]);
    %% 分不同行为进行SL计算
    bhv_name=fieldnames(behavior);
    fread=0;
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        for freq_idx=1:length(LP)
            freq=['_L' num2str(LP(freq_idx)) '_H' num2str(HS(freq_idx))];
            fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'sl_' fieldname freq '.mat'];
            %% data_reorganize,降采样
            %取50个数据点时长为1.5个低频周期
            res_fs=(3*HS(freq_idx));

            if isempty(dir(fname))&&isempty(dir([fname(1:end-4) '_temp.mat']))   %如果文件已经计算过或正在计算，则跳过
                %将文件存入本地再读取
                SL=[];
                time_ind_back=0;
                save([fname(1:end-4) '_temp'],'SL','time_ind_back');
                if fread==0
                    uni_file=[num2str([bhv]) num2str(freq_idx)];
                    mat_name=[matfile(file_idx).name(1:end-4) uni_file '.mat'];
                    system(['copy "' pwd '\' matfile(file_idx).name '" c:\' mat_name]);
                    cwd=pwd;
                    cd('c:\');
                    rawdata=load(mat_name);
                    system(['del ' mat_name]);
                    cd(cwd);
                    fread=1;
                end
                %% 改变时间单位
                step_len=[1000/res_fs,1000/res_fs];   %in ms
                cal_range=[stps(2)-stps(1),delays(2)-delays(1)]; %in ms
                step_num=max(cal_range./step_len);
                step=ceil(step_num./max_steps);
                start_offset=stps(1)/1000;
                stps_fixed=0:step:ceil(cal_range(1)*res_fs/1000);
%                 stps_fixed=floor(stps(1)*res_fs/1000):step:ceil(stps(2)*res_fs/1000);
                delays_fixed=floor(delays(1)*res_fs/1000):step:ceil(delays(2)*res_fs/1000);
                
                %% channel picking筛选出有效通道
                chans=channelpick(fieldnames(rawdata),'elec');
                eval(['bhv_time=behavior.' fieldname ';']);
                rawdata_valid=cell(length(chans),1);
                for i = 1:length(chans)
                    eval(['rawdata_valid{i} = resample(rawdata.elec' num2str(chans(i)) ',res_fs,system_fs);']);
                end
            
                if(isempty(bhv_time))
                    starts=[];
                    ends=[];
                else
                    if size(bhv_time,2)==1
                        bhv_time(:,2)=bhv_time(:,1)+15;
                    end
                    starts_ori=bhv_time(:,1)+start_offset;
                    ends_ori=bhv_time(:,2);
                    idx=find(floor((ends_ori-starts_ori)*res_fs)>0 & starts_ori>0);
                    if isempty(idx)
                        starts=[];
                        ends=[];
                    else
                        starts=starts_ori(idx);
                        ends=ends_ori(idx);
                    end
                end
                
%                 try
                    cwd=pwd;
                    old_file=dir(['c:\' fname ]);
                    
                    if isempty(old_file)
                        %进行sl计算
                        SL=SL_LFP_twosided(rawdata_valid,res_fs,starts,ends,chans,LP(freq_idx),HS(freq_idx),n_rec,p_ref,stps_fixed,delays_fixed,fname(1:end-4),n_level);
                        SL.startpoint=SL.startpoint+stps(1);
                        cd('C:\')
                        save(fname,'-struct','SL');
                    end
                    cd('C:\')
                    %存储数据
                    system(['copy c:\' fname ' "' cwd '"']);
                    system(['del c:\' fname ]);
                    cd(cwd);
                    clear('SL')
                    
%                 catch err
%                     system(['rename ' fname(1:end-4) '_temp.mat ' fname(1:end-4) '_fail.mat']);   %如果计算出现故障，则将temp重命名为fail
%                 end
            end
            multiWaitbar('Frequency bands:',freq_idx/length(LP),'color',[0.8 0.5 0.3]);
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end