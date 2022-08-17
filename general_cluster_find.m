function general_cluster_find(searchkeyword,min_area,max_ecc,min_I,min_percent,plot_on,cluster_method)
% revised by zifang zhao @ 2012-12-29 修正了对于起始时间不为0的数据处理问题
% revised by zifang zhao @ 2012-12-16 修正了对计算二维延时时如果存在分析间隔时的分析错误,优化速度
% revised by zifang zhao @ 2012-12-9 优化远程文件读取，先保存到本地,修正原始结果中的不足长度部分导致的空集报错
% revised by zifang zhao @ 2012-10-31 修正起始时间，改为从0开始，修正强度值（上一版本错乘1000/fs）
% revised by zifang zhao @ 2012-9-27 将cluster的值合并到loc的第三维
% revised by zifang zhao @ 2012-9-14 为了排除自相关通道的影响，在通道号idx=idy时跳过计算
% revised by Zifang Zhao @ 2012-6-23 使结果处于.data级别，方便以后处理，整合了更新老式数据的功能
%revised by zifang zhao @ 2012-9-3 修正结果，使输出的时间单位为毫秒
%revised by zifang zhao @ 2012-9-7
%增加新的提取方式，增加新的参数输入对clustering的方式进行控制,改stds为vals
matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
analyzed_idx=cell2mat(cellfun(@(x) isempty(x),strfind({matfile.name},'analyzed'),'UniformOutput',0)); %避免将计算结果重新纳入
temp_idx=cell2mat(cellfun(@(x) isempty(x),strfind({matfile.name},'temp'),'UniformOutput',0)); %避免纳入临时结果
matfile=matfile(analyzed_idx&temp_idx);
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);
for file_idx=1:length(matfile)
    
    %% load MAT-files
    fname=[matfile(file_idx).name(1:end-4) '_analyzed.mat'];
    if isempty(dir(fname)) %skip calculated
        system(['copy "' pwd '\' matfile(file_idx).name '" c:\']);
        cwd=pwd;
        cd('c:\');
        rawdata=load(matfile(file_idx).name);
        system(['del ' matfile(file_idx).name]);
        cd(cwd);
        cal_data=reformat_nonstruct_pcmi(rawdata,200,3,6); %读取数据，并将老式的npcmi数据更新为新格式
        msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
        
        %进行特征提取
        Ncal_name=fieldnames(cal_data.data); %从通用延时结构中提取相应的计算文件名
        for field_idx=1:length(Ncal_name)
            temp=getfield(cal_data.data,Ncal_name{field_idx});
            cal_data.data=rmfield(cal_data.data,Ncal_name{field_idx});
%             eval(['cal_data.data.' Ncal_name{field_idx} '=[];']);
            non_empty=~cellfun(@isempty,temp);
            temp_field=temp(non_empty); clear('temp')
            trials=length(temp_field);
            locs=cell(trials,1);
            vals=cell(trials,1);
            fs=cal_data.fs;
            t_step=cal_data.startpoint(2)-cal_data.startpoint(1);
            parfor trial=1:trials
%                 temp_locs=cell(size(temp_field));
%                 temp_vals=cell(size(temp_field));
                temp_trial=temp_field{trial};
                [idx,idy]=meshgrid(1:size(temp_trial,1),1:size(temp_trial,2));
                if cluster_method==0
                    locs{trial}=arrayfun(@(x,y) cluster_find_shell(temp_trial{x,y},min_area,max_ecc,min_I,min_percent,plot_on,t_step,cal_data.startpoint(1),cal_data.delay(1),x==y),idx,idy,'UniformOutput',0)';
                else
                    locs{trial}=arrayfun(@(x,y) loc_find_shell(temp_trial{x,y},min_I,min_percent,t_step,cal_data.startpoint(1),cal_data.delay(1),x==y),idx,idy,'UniformOutput',0)';
                end
            end
            
            cal_data.data=setfield(cal_data.data,[Ncal_name{field_idx} '_locs'],locs);
%             cal_data.data=setfield(cal_data.data,[Ncal_name{field_idx} '_vals'],vals);
            cal_data.min_area=min_area;
            cal_data.max_ecc=max_ecc;
            cal_data.min_I=min_I;
            cal_data.min_percent=min_percent;
            cal_data.cluster_method=cluster_method;
%             eval(['cal_data.data.' Ncal_name{field_idx} '_stds=stds;' ]);
        end
        save(fname,'-struct','cal_data');
    end

    
    
    %存储数据
    
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
    
end

end


function tempA=loc_find_shell(N_data,min_I,min_percent,t_step,st0,dl0,skip)
if skip==1
    tempA=[];
else
    [tempA]=loc_find(N_data,min_I,min_percent);
    if ~isempty(tempA)
        tempA(:,1:2)=(tempA(:,1:2)-1)*t_step;
        tempA(:,1)=tempA(:,1)+st0;
        tempA(:,2)=tempA(:,2)+dl0;
    end
end
end

function tempA=cluster_find_shell(N_data,min_area,max_ecc,min_I,min_percent,plot_on,t_step,st0,dl0,skip)
if skip==1
    tempA=[];
else
    [tempA]=cluster_find(N_data,min_area,max_ecc,min_I,min_percent,plot_on);
    if ~isempty(tempA)
        tempA(:,1:2)=(tempA(:,1:2)-1)*t_step;
        tempA(:,1)=tempA(:,1)+st0;
        tempA(:,2)=tempA(:,2)+dl0;
    end
end
end