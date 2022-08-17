%% statistical analysis of PCMI data
function stat_general()
sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker 
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end

[filename pathname]=uigetfile('*.mat','Select montage definition');
m=load([pathname filename]);    %montage
montage=m.montage;
[filename pathname]=uigetfile('*.mat','Select fixed grouped PCMI data');
m=load([pathname filename]);    %grouped
grouped_data=m.grouped_data;
channel_all=[];
for m=1:length(montage)
    channel_all=[channel_all montage{m}.channel];
end

map_attr_temp=cellfun(@(x) x.attrname',grouped_data,'UniformOutput',false);
map_attr_all=[map_attr_temp{:}];
map_attr_grouped=cell(1,size(map_attr_all,1));
for m=1:size(map_attr_all,1)
    map_attr_grouped{m}=unique([map_attr_all{m,:}]);
end

attr_idx_temp=cellfun(@(x) x.attr,grouped_data,'UniformOutput',false);
attr_idx=[attr_idx_temp{:}];
% stat_fig('map_all',map_grouped)
[~,rat_attr,rat_idx]=stat_fig(map_attr_grouped);
attr_idx_left=1:length(map_attr_grouped);
attr_idx_left(rat_attr)=[];
% %% merge Ixy,Iyx and delay to Ixy_delay ,Iyx_delay 为了和原程序匹配
% for group=1:length(grouped_data)
%     grouped_combined_data{group}.Ixy_delay{1}=cellfun(@matrix_merge_vertical,grouped_data{group}.data.Ixys,grouped_data{group}.data.delay,'UniFormOutput',false);
%     grouped_combined_data{group}.Iyx_delay{1}=cellfun(@matrix_merge_vertical,grouped_data{group}.data.Iyxs,grouped_data{group}.data.delay,'UniFormOutput',false);
% end
%%  region vs region
dirname=[pwd '\pic\'];
mkdir(dirname);
idx=0;
multiWaitbar('Close all');
for rat=1:length(rat_idx)
    multiWaitbar('Data idx',rat/length(rat_idx),'Color',[0.1 0.5 0.8]);
    rat_selected=attr_idx(:,attr_idx(rat_attr,:)==rat_idx(rat));
    for current=1:size(rat_selected,2)
        multiWaitbar('Trial',current/length(rat_selected),'Color',[0.5 0.5 0.1]);
        different_table=arrayfun(@(x,y) x~=y,rat_selected,repmat(rat_selected(:,1),[1 size(rat_selected,2)]));
        compare_set=find(sum(different_table,1)==1);
        group1=find(any(attr_idx-repmat(rat_selected(:,current),[1 size(attr_idx,2)]),1)==0); %找出在group_idx对应的位置
        for compare=compare_set
            group2=find(any(attr_idx-repmat(rat_selected(:,compare),[1 size(attr_idx,2)]),1)==0); %找出在group_idx对应的位置
            for region1=1:length(montage)
                for region2=region1:length(montage)
                    channel_mask=zeros(length(channel_all));
                    channel_mask(montage{region1}.channelNo,montage{region2}.channelNo)=1;
                    %                     a=grouped_data{group1}.data.Ixys;
                    %                     b=grouped_data{group2}.data.Ixys;
                    %                     c=isequal(a,b);
                    Xmax1_Ixy=cellfun(@I_extractor_Ixy,grouped_data{group1}.data.Xmax,'UniformOutput',false);
%                     Xmax1_Iyx=cellfun(@I_extractor_Iyx,grouped_data{group1}.data.Xmax,'UniformOutput',false);
                    Xmax1_delay=cellfun(@I_extractor_delay,grouped_data{group1}.data.Xmax,'UniformOutput',false);
%                     Xmax1_DP=cellfun(@I_extractor_DP,grouped_data{group1}.data.Xmax,'UniformOutput',false);
                    Xmax2_Ixy=cellfun(@I_extractor_Ixy,grouped_data{group2}.data.Xmax,'UniformOutput',false);
%                     Xmax2_Iyx=cellfun(@I_extractor_Iyx,grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    Xmax2_delay=cellfun(@I_extractor_delay,grouped_data{group2}.data.Xmax,'UniformOutput',false);
%                     Xmax2_DP=cellfun(@I_extractor_DP,grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    [t_test_current ks_test_current]=pcmi_region_stat_new(Xmax1_Ixy,Xmax1_delay,Xmax2_Ixy,Xmax2_delay,channel_mask,channel_mask,...
                        dirname,[grouped_data{group1}.attrname{3}{1} ' ' grouped_data{group1}.attrname{1}{1} ' ' grouped_data{group1}.attrname{2}{1} ' vs ' grouped_data{group2}.attrname{3}{1} ' ' grouped_data{group2}.attrname{1}{1} ' ' grouped_data{group2}.attrname{2}{1} '@' montage{region1}.name ' '...
                        montage{region2}.name],montage{region1}.name,montage{region2}.name,sch);
                    idx=idx+1;
                    test_result{idx}.attr{1}=grouped_data{group1}.attr;
                    test_result{idx}.attr{2}=grouped_data{group2}.attr;
                    test_result{idx}.attrname{1}=grouped_data{group1}.attrname;
                    test_result{idx}.attrname{2}=grouped_data{group2}.attrname;
                    test_result{idx}.region{1}=montage{region1}.name;
                    test_result{idx}.region{2}=montage{region2}.name;
                    test_result{idx}.t_test=t_test_current;
                    test_result{idx}.ks_test=ks_test_current;
                end
            end
        end
    end
end
save([filename(1:end-4) '_result'],'test_result')
% for group1=1:length(rat_idx)
%     for attr=attr_idx_left
%         for sub_attr1=1:length(map_attr_grouped{attr})
% %     for group2=group1:length(rat_idx);
%             for region1=1:length(montage)
%                 for region2=region1:length(montage)
%                     channel_mask=zeros(length(channel_all));
%                     channel_mask(montage{region1}.channel,montage{region2}.channel)=1;
%                     [t_test ks_test]=pcmi_region_stat_new(grouped_data{group1}.data.Ixys,...
%                         grouped_data{group1}.data.delay,grouped_data{group2}.data.Ixys,...
%                         grouped_data{group2}.data.delay,channel_mask,channel_mask,...
%                         [grouped_data{group1}.attrname{1}{1} '_' grouped_data{group1}.attrname{2}{1} '_' montage{region1}.name '_'...
%                         montage{region2}.name],'A','B');
%                 end
%             end
%         end
% %     end
%     end
% end
% close all;
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
function y=I_extractor_delay(x)
if(isempty(x))
    y=[];
else
    y=x(3,:);
end
end
function y=I_extractor_DP(x)
if(isempty(x))
    y=[];
else
    y=x(4,:);
end
end