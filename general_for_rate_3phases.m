%% general  PCMI for formalin
function [chans,rate]=general_for_rate_3phases(time_range)
%% load 行为xls (including starts,ends)
% bhvfile=dir('*.xls');
% newData = importdata(bhvfile.name);
% clear('bhvfile');
%% load MAT-files
matfile=dir('*002.mat');
days=cell(1,length(matfile));
for i=1:length(matfile)
    days{i}=load(matfile(i).name);
end
%% channel picking
chans=channelpick(fieldnames(days{1}),'unit2');
%% data_reorganize
for i = 1:length(chans)
    eval(['channels_ori{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2;']);
end
%% 分不同行为、3个时相进行PCMI计算
phas_size=size(time_range);
% bhv_name=fieldnames(newData);
% datasheet_size=size(fieldnames(newData));

for phas=1:phas_size(1);   
    %再读取开始、结束时间
    %进行pcmi计算
    starts=time_range(phas,1);
    ends=time_range(phas,2);
    
    for i=1:length(channels_ori)
        tobe=channels_ori{1,i};
        counts=length(find(tobe>starts & tobe<ends));
        rate(i,phas)=counts/(ends-starts);
    end

%     
    %存储数据
%     filename=matfile(1).name;
%     fname=[filename(1:end-4) suffix{phas} '.mat'];
%     save(fname,'rate');
%     clear('DP_indexs','DP_index_mean','Ixy_max','Iyx_max','Ixys','Iyxs')
end

end
