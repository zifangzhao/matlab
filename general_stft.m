function general_stft(searchkeyword,system_fs,res_fs,time_to_cal,window,noverlap,nfft,n_level)
% revised by zifang zhao @ 2012-4-17    修正对excel格式以及单行时间点的支持
%%created by ZifangZhao @ 2013-2-1 based on general_sl_multidelay

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
%     multiWaitbar('Frequency bands:',0,'color',[0.8 0.5 0.3]);
    %% 分不同行为进行SL计算
    bhv_name=fieldnames(behavior);
    fread=0;
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'stft_' fieldname  '.mat'];


        
        if isempty(dir(fname))&&isempty(dir([fname(1:end-4) '_temp.mat']))   %如果文件已经计算过或正在计算，则跳过
            %将文件存入本地再读取
            STFT=[];
            time_ind_back=0;
            save([fname(1:end-4) '_temp'],'STFT','time_ind_back');
            if fread==0
                uni_file=[num2str([bhv]) ];
                mat_name=[matfile(file_idx).name(1:end-4) uni_file '.mat'];
                system(['copy "' pwd '\' matfile(file_idx).name '" c:\' mat_name]);
                cwd=pwd;
                cd('c:\');
                rawdata=load(mat_name);
                system(['del ' mat_name]);
                cd(cwd);
                fread=1;
            end

            %% channel picking筛选出有效通道
            chans=channelpick(fieldnames(rawdata),'elec');
            eval(['bhv_time=behavior.' fieldname ';']);
            rawdata_valid=cell(length(chans),1);
            for i = 1:length(chans)
                eval(['rawdata_valid{i} = resample(rawdata.elec' num2str(chans(i)) ',res_fs,system_fs);']);
            end
            
            trim_len=round(time_to_cal/1000*res_fs);
            
            if(isempty(bhv_time))
                starts=[];
                ends=[];
            else
                if size(bhv_time,2)==1
                        bhv_time(:,2)=bhv_time(:,1)+15;
                end
                starts_ori=bhv_time(:,1)-time_to_cal/1000;   %从window的负trim_len处开始计算
                ends_ori=bhv_time(:,2);
                idx=find(floor((ends_ori-starts_ori)*res_fs)>2*trim_len & starts_ori>0);
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
                %进l计算
                
                STFT=stft(rawdata_valid,res_fs,starts,ends,chans,2*trim_len,window,noverlap,nfft,fname(1:end-4),n_level);
                
                cd('C:\')
                save(fname,'-struct','STFT');
            end
            cd('C:\')
            %存储数据
            system(['copy c:\' fname ' "' cwd '"']);
            system(['del c:\' fname ]);
            cd(cwd);
            clear('STFT')
            
            %                 catch err
            %                     system(['rename ' fname(1:end-4) '_temp.mat ' fname(1:end-4) '_fail.mat']);   %如果计算出现故障，则将temp重命名为fail
            %                 end
            
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end