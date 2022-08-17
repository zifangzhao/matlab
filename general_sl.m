%generalized Synlike
%2012-4-13 revised by Zifang Zhao 改正生成文件名的问题,增加并行resample,hwt
%2012-4-12 created by Zifang Zhao 通用SL计算
function general_sl(searchkeyword,system_fs,res_fs,f1,f2,timerange,LF,HF,p_ref,n_ref,attrname)
matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);
%参数变换
timedelay=max(floor(res_fs./HF/3),1);% L
embedding=max(floor(3*HF./LF)+1,1);% m
w1=max(timedelay.*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–11`25中的w1的一半
w2=ceil(n_ref/p_ref/2)+w1-1;% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w2的一半
s=max(floor(w1),1);

for file_idx=1:length(matfile)
    %% load MAT-files
    rawdata=load(matfile(file_idx).name);
    msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
    %% load 行为xls (including starts,ends)
    filename=[matfile(file_idx).name(1:end-4) '.xls'];
    [~,field_names,~]=xlsfinfo(filename);
    if length(field_names)>1
        behavior = importdata(filename);
    else
        eval(['behavior.' field_names{1} '=importdata(filename);']);
    end
    %% channel picking筛选出有效通道
    chans=channelpick(fieldnames(rawdata),'elec');
    
    
    multiWaitbar('Sub classifications:',0,'color',[0.5 1 0.5]);
    %% 分不同行为进行SL计算
    bhv_name=fieldnames(behavior);
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'sl_' fieldname '_' attrname '.mat'];
        if isempty(dir(fname))
            eval(['bhv_time=behavior.' fieldname ';']);
            bhv_time=findinrange(bhv_time,timerange);
            if(isempty(bhv_time))
                starts=[];
                ends=[];
            else
                
                starts=bhv_time(:,1);
                ends=bhv_time(:,2);
                %% data_reorganize
                SPEC=cell(length(starts));
                LFP=cell(length(starts));
                for trial=1:length(starts)
                    for channel_idx = 1:length(chans)
                        eval(['LFP{trial}(:,channel_idx) = rawdata.elec' num2str(chans(channel_idx)) '(floor(starts(trial)*system_fs):ceil(ends(trial)*system_fs));']);
                    end
                end
                parfor trial=1:length(starts)
                    for channel_idx = 1:length(chans)
                        SPEC{trial}(:,channel_idx)=hwt(resample(LFP{trial}(:,channel_idx),res_fs,system_fs),f1,f2,res_fs);
                    end
                end
                %进行SL计算
                parfor trial=1:size(SPEC,2)
                    SL(:,:,trial)=SynLikeMatrix(squeeze(SPEC{trial})',timedelay(1),embedding(1),w1(1),w2(1),p_ref,n_ref,s(1));
                end
                %eliminate all NaN matrix
                
                %存储数据
                save(fname,'SL');
            end
            
            
            
            
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end