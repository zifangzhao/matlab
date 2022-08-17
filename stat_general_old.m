%% statistical analysis of PCMI data
function stat_general(fs)
%%2012-4-13 revised by Zifang Zhao 修正batch使用内存过多的问题
%%2012-4-12 revised by Zifang Zhao 增加采样率输入，修正时间坐标
%%2012-4-9  revised by zifang zhao 更改图命名规则
%%2012-4-8  revised by 加入手动选择数据
%%2012-3-26 revised by 将montage关键词替换,增加可选dir位置
sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end
jobhandle=[];
[filename pathname]=uigetfile('*.mat','Select rat_montage definition');
m=load([pathname filename]);    %rat_montage
rat_montage=m.rat_montage;
[filename pathname]=uigetfile('*.mat','Select grouped data');
m=load([pathname filename]);    %grouped
mfield=fieldnames(m);
str=mfield;
[s,v] = listdlg('PromptString','Select data label',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str{s};
clear('str','s','v');
eval(['grouped_data=m.' selected ';']);
channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];
end

map_attr_temp=cellfun(@(x) x.attrname',grouped_data,'UniformOutput',false); %作出分组名称列表
map_attr_all=[map_attr_temp{:}];
map_attr_grouped=cell(1,size(map_attr_all,1));
for m=1:size(map_attr_all,1)
    map_attr_grouped{m}=unique([map_attr_all{m,:}]);
end

attr_idx_temp=cellfun(@(x) x.attr,grouped_data,'UniformOutput',false);  %作出分组序号列表
attr_idx=[attr_idx_temp{:}];
% stat_fig('map_all',map_grouped)
[~,rat_attr,rat_idx]=stat_fig(map_attr_grouped);  %返回需要不需要比较的标签和相应的index
attr_idx_left=1:length(map_attr_grouped);          %除去同级的标签剩余的标签
attr_idx_left(rat_attr)=[];
% %% merge Ixy,Iyx and delay to Ixy_delay ,Iyx_delay 为了和原程序匹配
% for group=1:length(grouped_data)
%     grouped_combined_data{group}.Ixy_delay{1}=cellfun(@matrix_merge_vertical,grouped_data{group}.data.Ixys,grouped_data{group}.data.delay,'UniFormOutput',false);
%     grouped_combined_data{group}.Iyx_delay{1}=cellfun(@matrix_merge_vertical,grouped_data{group}.data.Iyxs,grouped_data{group}.data.delay,'UniFormOutput',false);
% end
%%  region vs region
% dirname=[pwd '\pic\'];
dirname=[uigetdir '\'];
% mkdir(dirname);
idx=0;
count=0;
multiWaitbar('Close all');
for rat=1:length(rat_idx)
    multiWaitbar('Data idx',rat/length(rat_idx),'Color',[0.1 0.5 0.8]);
    rat_selected=attr_idx(:,attr_idx(rat_attr,:)==rat_idx(rat)); %从原始标签中找出与rat相对应的标签
    for current=1:size(rat_selected,2)
        multiWaitbar('Trial',current/length(rat_selected),'Color',[0.5 0.5 0.1]);
        different_table=arrayfun(@(x,y) x~=y,rat_selected,repmat(rat_selected(:,1),[1 size(rat_selected,2)])); %从选出的所有标签中作出与当前文件各标签是否相同的表
        compare_set=find(sum(different_table,1)==1);
        group1=find(any(attr_idx-repmat(rat_selected(:,current),[1 size(attr_idx,2)]),1)==0); %找出在group_idx对应的位置
        for compare=compare_set
            group2=find(any(attr_idx-repmat(rat_selected(:,compare),[1 size(attr_idx,2)]),1)==0); %找出在group_idx对应的位置
            for region1=1:length(rat_montage)
                for region2=region1:length(rat_montage)
                    channel_mask=zeros(length(channel_all));
                    channel_mask(rat_montage{region1}.channelNo,rat_montage{region2}.channelNo)=1;
                    %                     a=grouped_data{group1}.data.Ixys;
                    %                     b=grouped_data{group2}.data.Ixys;
                    %                     c=isequal(a,b);
                    Xmax1_Ixy=cellfun(@I_extractor_Ixy,grouped_data{group1}.data.Xmax,'UniformOutput',false);
                    %                     Xmax1_Iyx=cellfun(@I_extractor_Iyx,grouped_data{group1}.data.Xmax,'UniformOutput',false);
                    Xmax1_delay=cellfun(@(x) I_extractor_delay(x,fs),grouped_data{group1}.data.Xmax,'UniformOutput',false);
                    Xmax1_DP=cellfun(@I_extractor_DP,grouped_data{group1}.data.Xmax,'UniformOutput',false);
                    Xmax2_Ixy=cellfun(@I_extractor_Ixy,grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    %                     Xmax2_Iyx=cellfun(@I_extractor_Iyx,grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    Xmax2_delay=cellfun(@(x) I_extractor_delay(x,fs),grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    Xmax2_DP=cellfun(@I_extractor_DP,grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    att_len=length(grouped_data{group1}.attrname);
                    nameA=[];
                    nameB=[];
                    for n=1:att_len
                        nameA=[nameA '_' grouped_data{group1}.attrname{n}{1}];
                        nameB=[nameB '_' grouped_data{group2}.attrname{n}{1}];
                    end
                    count=count+1;
                    [t_test_current ks_test_current ks_curve jobnew]=pcmi_region_stat_new(grouped_data{group1}.data.Ixys,grouped_data{group1}.data.delay,grouped_data{group2}.data.Ixys,grouped_data{group2}.data.delay,channel_mask,channel_mask,...
                        dirname,['Ixys_delay_' nameA ' vs ' nameB '@' rat_montage{region1}.name ' '...
                        rat_montage{region2}.name],nameA,nameB,sch);
                    jobhandle=[jobhandle jobnew];
                    if count>50
                        count=0;
                        if isempty(jobhandle)
                        else
                            wait(jobhandle(end));
                            for idx=1:length(jobhandle)
                                destroy(jobhandle(1));
                                jobhandle(1)=[];
                            end
                            sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker
                            if(isempty(sch.jobs))
                            else
                                destroy(sch.jobs);
                            end
                        end
                    end
                    %                     [t_test_current ks_test_current]=pcmi_region_stat_new(Xmax1_DP,Xmax1_delay,Xmax2_DP,Xmax2_delay,channel_mask,channel_mask,...
                    %                         dirname,['DP_delay_' grouped_data{group1}.attrname{3}{1} ' ' grouped_data{group1}.attrname{1}{1} ' ' grouped_data{group1}.attrname{2}{1} ' vs ' grouped_data{group2}.attrname{3}{1} ' ' grouped_data{group2}.attrname{1}{1} ' ' grouped_data{group2}.attrname{2}{1} '@' rat_montage{region1}.name ' '...
                    %                         rat_montage{region2}.name],rat_montage{region1}.name,rat_montage{region2}.name,sch);
                    idx=idx+1;
                    test_result{idx}.attr{1}=grouped_data{group1}.attr;
                    test_result{idx}.attr{2}=grouped_data{group2}.attr;
                    test_result{idx}.attrname{1}=grouped_data{group1}.attrname;
                    test_result{idx}.attrname{2}=grouped_data{group2}.attrname;
                    test_result{idx}.region{1}=rat_montage{region1}.name;
                    test_result{idx}.region{2}=rat_montage{region2}.name;
                    test_result{idx}.t_test=t_test_current;
                    test_result{idx}.ks_test=ks_test_current;
                    test_result{idx}.ks_curve=ks_curve;
                end
            end
        end
    end
end
cd(dirname);
save([filename(1:end-4) '_result'],'test_result')
% for group1=1:length(rat_idx)
%     for attr=attr_idx_left
%         for sub_attr1=1:length(map_attr_grouped{attr})
% %     for group2=group1:length(rat_idx);
%             for region1=1:length(rat_montage)
%                 for region2=region1:length(rat_montage)
%                     channel_mask=zeros(length(channel_all));
%                     channel_mask(rat_montage{region1}.channel,rat_montage{region2}.channel)=1;
%                     [t_test ks_test]=pcmi_region_stat_new(grouped_data{group1}.data.Ixys,...
%                         grouped_data{group1}.data.delay,grouped_data{group2}.data.Ixys,...
%                         grouped_data{group2}.data.delay,channel_mask,channel_mask,...
%                         [grouped_data{group1}.attrname{1}{1} '_' grouped_data{group1}.attrname{2}{1} '_' rat_montage{region1}.name '_'...
%                         rat_montage{region2}.name],'A','B');
%                 end
%             end
%         end
% %     end
%     end
% end
% close all;
multiWaitvbar('Closeall');
end

function y=I_extractor_Ixy(x)
if(isempty(x))
    y=[];
else
    y=x(1,:);
end
end
function y=I_extractor_Iyx(x)
if(isempty(x))
    y=[];
else
    y=x(2,:);
end
end
function y=I_extractor_delay(x,fs)
if(isempty(x))
    y=[];
else
    y=x(3,:).*1000/fs;
end
end
function y=I_extractor_DP(x)
if(isempty(x))
    y=[];
else
    y=x(4,:);
end
end