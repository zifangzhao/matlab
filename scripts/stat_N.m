function stat_N()
% 2012-6-17 created by zifang zhao REF:stat_pcmi for generalized delay
% structure statistic
cwd=pwd; %保护当前工作路径
%% 查找可用的处理器资源，清除之前的job
sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end
jobhandle=[];

%% 读取数据
[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
m=load([pathname filename],'-mat');    %rat_montage
rat_montage=m.rat_montage;
[filename pathname]=uigetfile('*.mat','Select grouped data');
m=load([pathname filename]);    %grouped
mfield=fieldnames(m.data);
str=mfield;
[s,~] = listdlg('PromptString','Select data label',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str{s};
clear('str','s');
grouped_data=getfield(m.data, selected);
% eval(['grouped_data=m.data.' selected ';']);
channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];    %合并montage中所有通道，做出通道列表
end

%根据文件名做出属性列表
map_attr_temp=cellfun(@(x) x.attrname',grouped_data,'UniformOutput',false); %作出分组名称列表
map_attr_all=[map_attr_temp{:}];
map_attr_grouped=cell(1,size(map_attr_all,1));
for m=1:size(map_attr_all,1)
    map_attr_grouped{m}=unique([map_attr_all{m,:}]);
end

attr_idx_temp=cellfun(@(x) x.attr,grouped_data,'UniformOutput',false);  %作出分组序号列表
attr_idx=[attr_idx_temp{:}];
% stat_fig('map_all',map_grouped)
[~,compare_attr,compare_idxsetA,compare_idxsetB]=stat_fig(map_attr_grouped);  %返回需要比较的标签和相应的index
temp=zeros(length(compare_idxsetA),1);
for idx=1:length(compare_idxsetA)
    n=map_attr_grouped{compare_attr}(compare_idxsetA(idx));
    loc=find(strcmp([map_attr_all{compare_attr,:}],n));
    temp(idx)=attr_idx(compare_attr,loc(1));
end
compare_idxsetA=temp;   %需要参与统计对比的数据集A在grouped_data中的序号集
temp=zeros(length(compare_idxsetB),1);
for idx=1:length(compare_idxsetB)
    n=map_attr_grouped{compare_attr}(compare_idxsetB(idx));
    loc=find(strcmp([map_attr_all{compare_attr,:}],n));
    temp(idx)=attr_idx(compare_attr,loc(1));
end
compare_idxsetB=temp;   %需要参与统计对比的数据集B在grouped_data中的序号集

%%  region vs region
dirname=[uigetdir(pwd,'Select result output folder') '\']; %选择结果保存位置

idx=0;
multiWaitbar('Close all');
multiWaitbar('Data idx',0,'Color',[0.1 0.5 0.8]);
multiWaitbar('Dataset A',0,'Color',[0.5 0.5 0.1]);
multiWaitbar('Dataset B',0,'Color',[0.5 0.8 0.3]);
for compare_idxA=1:length(compare_idxsetA) %比较数据集A
    
    data_selectedA=attr_idx(:,attr_idx(compare_attr,:)==compare_idxsetA(compare_idxA)); %从原始数据标签集中找出需要分析的标签集合
    for currentA=1:size(data_selectedA,2)
        
        %         different_table=arrayfun(@(x,y) x~=y,data_selectedA,repmat(data_selectedA(:,1),[1 size(data_selectedA,2)])); %从选出的所有标签中作出与当前文件各标签是否相同的表
        group1=find(any(attr_idx-repmat(data_selectedA(:,currentA),[1 size(attr_idx,2)]),1)==0); %找出在group_idx对应的位置
        currentA_attr=data_selectedA(:,currentA);
        for compare_idxB=1:length(compare_idxsetB) %比较数据集B
            %             data_selectedB=attr_idx(:,attr_idx(compare_attr,:)==compare_idxsetB(compare_idxB)); %从原始数据标签集中找出需要分析的标签集合
            %             for currentB=1:size(data_selectedB,2)
            
            currentB_attr=currentA_attr;
            currentB_attr(compare_attr)=compare_idxsetB(compare_idxB);
            group2=find(any(attr_idx-repmat(currentB_attr,[1 size(attr_idx,2)]),1)==0); %找出在group_idx对应的位置
            for region1=1:length(rat_montage)
                for region2=region1:length(rat_montage)
                    idx=idx+1;
                    test_result{idx}.attr{1}=grouped_data{group1}.attr;
                    test_result{idx}.attr{2}=grouped_data{group2}.attr;
                    test_result{idx}.attrname{1}=grouped_data{group1}.attrname;
                    test_result{idx}.attrname{2}=grouped_data{group2}.attrname;
                    test_result{idx}.region{1}=rat_montage{region1}.name;
                    test_result{idx}.region{2}=rat_montage{region2}.name;
                end
            end
            %             end
            multiWaitbar('Dataset B',compare_idxB/length(compare_idxsetB),'Color',[0.5 0.8 0.3]);
        end
        multiWaitbar('Dataset A',currentA/length(data_selectedA),'Color',[0.5 0.5 0.1]);
    end
    multiWaitbar('Data idx',compare_idxA/length(compare_idxsetA),'Color',[0.1 0.5 0.8]);
end
              
cd(dirname);
% cd('..')
save([filename(1:end-4) '_result'],'test_result')
if isempty(jobhandle)
else
    wait(jobhandle(end));
end

cd(cwd);
multiWaitbar('Closeall');
end

function Ndelay(Ndata,`channel_setA,channel_setB)

end