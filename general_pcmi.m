%% general  PCMI for formalin
function general_pcmi(time_range)
%% load 行为xls (including starts,ends)
bhvfile=dir('*.xls');
newData = importdata(bhvfile.name);
clear('bhvfile');
%% load MAT-files
matfile=dir('*.mat');
days=cell(1,length(matfile));
for i=1:length(matfile)
    days{i}=load(matfile(i).name);
end
%% channel picking
chans=channelpick(fieldnames(days{1}),'_unit2'); %挑出原始文件中的有效通道
%% data_reorganize
for i = 1:length(chans)
    eval(['channels_ori{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2;']);
end

%% 分不同行为、3个时相进行PCMI计算
phas_size=size(time_range);
bhv_name=fieldnames(newData);
datasheet_size=size(fieldnames(newData));
for bhv=1:datasheet_size(1);
    fieldname=bhv_name(bhv);fieldname=fieldname{1};
    for phas=1:phas_size(1);
        %先由time_range进行截取
        eval(['temp=newData.' fieldname ';'])
        bhv_time=findinrange(temp,time_range(phas,:)); clear temp; %从xls定义的时间范围内查找范围内的trial
        %再读取开始、结束时间
        if(isempty(bhv_time))
            starts=[];
            ends=[];
        else
            starts=bhv_time(:,1);
            ends=bhv_time(:,2);
        end
        
        %进行pcmi计算
        [DP_indexs,DP_index_mean,Ixy_max,Iyx_max,Ixys,Iyxs]=pcmi(channels_ori,starts,ends,chans,10);
        
        %存储数据
        filename=matfile(1).name;
        fname=[filename(1:end-4) '_' fieldname num2str(phas) '.mat'];
        save(fname,'DP_indexs','DP_index_mean','Ixy_max','Iyx_max','Ixys','Iyxs');
        clear('DP_indexs','DP_index_mean','Ixy_max','Iyx_max','Ixys','Iyxs')
    end
end
end