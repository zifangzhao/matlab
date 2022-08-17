%% statistical analysis of PCMI data
function stat_pcmi(hist_diff_range,fs)
% 2012-4-22 revised by Zifang Zhao 将scatterplot加入jobhandle控制
% 2012-4-21 revised by Zifang Zhao
% 将采样率输入放到第二个，原始数据中已修正，此参数配合错误输入的数据或老版本，montage变为新的后缀
% 2012-4-19 revised by Zifang zhao 将test结果变为新的格式：.tests.datatype.testtype.testvalues
% 2012-4-18 revised by Zifang Zhao 修正scatter2,3的delay显示错误,修正legend标签选择
% 2012-4-17 revised by Zifang Zhao 增加Iyx_delay的各项结果，增加等待sch出结果
% 2012-4-16 revised by Zifang Zhao
% 增加hist_diff_range,修正跑完文件夹位置不在原路径问题，第二次修正时间坐标，修正进度条提前问题
% 修正DP中0，inf的问题，将其完全剔除
% 2012-4-16 revised by Zifang Zhao 修正丢图问题
% 2012-4-15 renamed from stat_general to stat_pcmi
% 2012-4-13 revised by Zifang Zhao 修正batch使用内存过多的问题
% 2012-4-12 revised by Zifang Zhao 增加采样率输入，修正时间坐标
% 2012-4-9  revised by zifang zhao 更改图命名规则
% 2012-4-8  revised by 加入手动选择数据
% 2012-3-26 revised by 将montage关键词替换,增加可选dir位置
cwd=pwd;
sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end
if nargin<1
    hist_diff_range=[-1 1];
end
if nargin<2
    fs=1000;
end
jobhandle=[];
[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
m=load([pathname filename],'-mat');    %rat_montage
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
[~,compare_attr,compare_idxsetA,compare_idxsetB]=stat_fig(map_attr_grouped);  %返回需要比较的标签和相应的index
temp=[];
for idx=1:length(compare_idxsetA)
    n=map_attr_grouped{compare_attr}(compare_idxsetA(idx));
    loc=find(strcmp([map_attr_all{compare_attr,:}],n));
    temp(idx)=attr_idx(compare_attr,loc(1));
end
compare_idxsetA=temp;
temp=[];
for idx=1:length(compare_idxsetB)
    n=map_attr_grouped{compare_attr}(compare_idxsetB(idx));
    loc=find(strcmp([map_attr_all{compare_attr,:}],n));
    temp(idx)=attr_idx(compare_attr,loc(1));
end
compare_idxsetB=temp;    

%% 选择需要显示的legend标签级别
str=cellfun(@(x) [x{:}],map_attr_grouped(:),'UniformOutput',0);
[s,v] = listdlg('PromptString','Select legend label groups for figures',...
    'SelectionMode','multiple',...
    'ListString',str);
legend_attr=s;
clear('str','s','v');
% attr_idx_left=1:length(map_attr_grouped);          %除去同级的标签剩余的标签
% attr_idx_left(compare_attr)=[];
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
                    channel_mask=zeros(length(channel_all));
                    channel_mask(rat_montage{region1}.channelNo,rat_montage{region2}.channelNo)=1;
                    %                     a=grouped_data{group1}.data.Ixys;
                    %                     b=grouped_data{group2}.data.Ixys;
                    %                     c=isequal(a,b);
%                     Xmax1_Ixy=cellfun(@I_extractor_Ixy,grouped_data{group1}.data.Xmax,'UniformOutput',false);
%                     Xmax1_Iyx=cellfun(@I_extractor_Iyx,grouped_data{group1}.data.Xmax,'UniformOutput',false);
%                     Xmax1_delay=cellfun(@(x) I_extractor_delay(x,fs),grouped_data{group1}.data.Xmax,'UniformOutput',false);
%                     Xmax1_DP=cellfun(@I_extractor_DP,grouped_data{group1}.data.Xmax,'UniformOutput',false);
%                     Xmax2_Ixy=cellfun(@I_extractor_Ixy,grouped_data{group2}.data.Xmax,'UniformOutput',false);
%                     Xmax2_Iyx=cellfun(@I_extractor_Iyx,grouped_data{group2}.data.Xmax,'UniformOutput',false);
%                     Xmax2_delay=cellfun(@(x) I_extractor_delay(x,fs),grouped_data{group2}.data.Xmax,'UniformOutput',false);
%                     Xmax2_DP=cellfun(@I_extractor_DP,grouped_data{group2}.data.Xmax,'UniformOutput',false);
                    delay1=cellfun(@(x) x*1000./fs,grouped_data{group1}.data.delay,'UniformOutput',false);
                    delay2=cellfun(@(x) x*1000./fs,grouped_data{group2}.data.delay,'UniformOutput',false);
                    att_len=length(grouped_data{group1}.attrname);
                    %legend name
                    nameA=[];
                    nameB=[];
                    for n=legend_attr
                        try
                            nameA=[nameA '_' grouped_data{group1}.attrname{n}{:}];
                            nameB=[nameB '_' grouped_data{group2}.attrname{n}{:}];
                        catch err
                        end
                    end
                    if ~isempty(nameA)
%                         nameA=[nameA];
                        nameA=nameA(2:end);
                    end
                    if ~isempty(nameB)
%                         nameB=[nameB];
                        nameB=nameB(2:end);
                    end
                    %filename
                    filenameA=[];
                    filenameB=[];
                    for n=1:length(grouped_data{group1}.attrname)
                        try
                            filenameA=[filenameA '_' grouped_data{group1}.attrname{n}{:}];
                            filenameB=[filenameB '_' grouped_data{group2}.attrname{n}{:}];
                        catch err
                        end
                    end
                    if ~isempty(filenameA)
%                         filenameA=[filenameA];
                        filenameA=filenameA(2:end);
                    end
                    if ~isempty(filenameB)
%                         filenameB=[filenameB];
                        filenameB=filenameB(2:end);
                    end
%                     count=count+1;
                    %find Imax_delay
                    [Ixy_delayA,Iyx_delayA,Ixy_DPA,Iyx_DPA]=Imax_delay(grouped_data{group1}.data.Ixys,grouped_data{group1}.data.Iyxs,delay1,channel_mask);
                    [Ixy_delayB,Iyx_delayB,Ixy_DPB,Iyx_DPB]=Imax_delay(grouped_data{group2}.data.Ixys,grouped_data{group2}.data.Iyxs,delay2,channel_mask);
                    %Ixy_delay
                    [t_test_Ixy ks_test_Ixy ks_curve_Ixy jobnew]=pcmi_region_stat_new(grouped_data{group1}.data.Ixys,delay1,grouped_data{group2}.data.Ixys,delay2,channel_mask,channel_mask,...
                        dirname,['Ixys_delay ' filenameA ' vs ' filenameB '@' rat_montage{region1}.name ' ' rat_montage{region2}.name],...
                        nameA,nameB,hist_diff_range,sch);
                    jobhandle=[jobhandle jobnew];
                    %Iyx_delay
                    [t_test_Iyx ks_test_Iyx ks_curve_Iyx jobnew]=pcmi_region_stat_new(grouped_data{group1}.data.Iyxs,delay1,grouped_data{group2}.data.Iyxs,delay2,channel_mask,channel_mask,...
                        dirname,['Iyxs_delay ' filenameA ' vs ' filenameB '@' rat_montage{region1}.name ' ' rat_montage{region2}.name],...
                        nameA,nameB,hist_diff_range,sch);
                    jobhandle=[jobhandle jobnew];
                    %DP_delay
                    [dp1 delay1_trimed]=cellfun(@cal_dp,grouped_data{group1}.data.Ixys,grouped_data{group1}.data.Iyxs,delay1,'UniformOutput',0);
                    [dp2 delay2_trimed]=cellfun(@cal_dp,grouped_data{group2}.data.Ixys,grouped_data{group2}.data.Iyxs,delay2,'UniformOutput',0);
                    
                    
                    [t_test_DP ks_test_DP ks_curve_DP jobnew]=pcmi_region_stat_new(dp1,delay1_trimed,dp2,delay2_trimed,channel_mask,channel_mask,...
                        dirname,['DP_delay ' filenameA ' vs ' filenameB '@' rat_montage{region1}.name ' ' rat_montage{region2}.name],...
                        nameA,nameB,hist_diff_range,sch);
                    jobhandle=[jobhandle jobnew];
                    %scatter plot
                    jobnew=pcmi_scatter(grouped_data{group1}.data.Ixys,grouped_data{group1}.data.Iyxs,delay1,...
                        grouped_data{group2}.data.Ixys,grouped_data{group2}.data.Iyxs,delay2,...
                        channel_mask,nameA,nameB,dirname,['Ixy_Iyx_delay ' filenameA ' vs ' filenameB '@' rat_montage{region1}.name ' ' rat_montage{region2}.name],sch);
                    jobhandle=[jobhandle jobnew];
                    %% 减轻内存负担
%                     if count>500
%                         count=0;
%                         if isempty(jobhandle)
%                         else
%                             wait(jobhandle(end));
%                             for idx=1:length(jobhandle)
%                                 destroy(jobhandle(1));
%                                 jobhandle(1)=[];
%                             end
%                             sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker
%                             if(isempty(sch.jobs))
%                             else
%                                 destroy(sch.jobs);
%                             end
%                         end
%                     end
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
                    %Ixy
                    test_result{idx}.tests.Ixys_delay.t_test.p=t_test_Ixy.p;
                    test_result{idx}.tests.Ixys_delay.t_test.t=t_test_Ixy.t;
                    test_result{idx}.tests.Ixys_delay.t_test.sd=t_test_Ixy.sd;
                    test_result{idx}.tests.Ixys_delay.ks_test.p=ks_test_Ixy.p;
                    test_result{idx}.tests.Ixys_delay.ks_test.t=ks_test_Ixy.ks;
                    test_result{idx}.tests.Ixys_delay.ks_test.cv=ks_test_Ixy.cv;
                    test_result{idx}.ks_curve.Ixys_delay=ks_curve_Ixy;
                    %Iyx
                    test_result{idx}.tests.Iyxs_delay.t_test.p=t_test_Iyx.p;
                    test_result{idx}.tests.Iyxs_delay.t_test.t=t_test_Iyx.t;
                    test_result{idx}.tests.Iyxs_delay.t_test.sd=t_test_Iyx.sd;
                    test_result{idx}.tests.Iyxs_delay.ks_test.p=ks_test_Iyx.p;
                    test_result{idx}.tests.Iyxs_delay.ks_test.t=ks_test_Iyx.ks;
                    test_result{idx}.tests.Iyxs_delay.ks_test.cv=ks_test_Iyx.cv;
                    test_result{idx}.ks_curve.Iyxs_delay=ks_curve_Iyx;
                    %DP
                    test_result{idx}.tests.DP_delay.t_test.p=t_test_DP.p;
                    test_result{idx}.tests.DP_delay.t_test.t=t_test_DP.t;
                    test_result{idx}.tests.DP_delay.t_test.sd=t_test_DP.sd;
                    test_result{idx}.tests.DP_delay.ks_test.p=ks_test_DP.p;
                    test_result{idx}.tests.DP_delay.ks_test.t=ks_test_DP.ks;
                    test_result{idx}.tests.DP_delay.ks_test.cv=ks_test_DP.cv;
                    
                    test_result{idx}.tests.DP_analysis.A.Ixy_delay=Ixy_delayA;
                    test_result{idx}.tests.DP_analysis.B.Ixy_delay=Ixy_delayB;
                    test_result{idx}.tests.DP_analysis.A.Iyx_delay=Iyx_delayA;
                    test_result{idx}.tests.DP_analysis.B.Iyx_delay=Iyx_delayB;
                    test_result{idx}.tests.DP_analysis.A.Ixy_DP=Ixy_DPA;
                    test_result{idx}.tests.DP_analysis.B.Ixy_DP=Ixy_DPB;
                    test_result{idx}.tests.DP_analysis.A.Iyx_DP=Iyx_DPA;
                    test_result{idx}.tests.DP_analysis.B.Iyx_DP=Iyx_DPB;
                    test_result{idx}.ks_curve.DP_delay=ks_curve_DP;
                end
            end
            %             end
            multiWaitbar('Dataset B',compare_idxB/length(compare_idxsetB),'Color',[0.5 0.8 0.3]);
        end
        multiWaitbar('Dataset A',currentA/length(data_selectedA),'Color',[0.5 0.5 0.1]);
    end
    multiWaitbar('Data idx',compare_idxA/length(compare_idxsetA),'Color',[0.1 0.5 0.8]);
end
% if isempty(jobhandle)
% else
%     wait(jobhandle(end));
%     for idx=1:length(jobhandle)
%         destroy(jobhandle(1));
%         jobhandle(1)=[];
%     end
%     sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker
%     if(isempty(sch.jobs))
%     else
%         destroy(sch.jobs);
%     end
% end
                        
cd(dirname);
% cd('..')
save([filename(1:end-4) '_result'],'test_result')
if isempty(jobhandle)
else
    wait(jobhandle(end));
end
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
cd(cwd);
multiWaitbar('Closeall');
end
function [dp delay]=cal_dp(Ixy,Iyx,delay)
dp=(Ixy-Iyx)./(Ixy+Iyx);
idx=isnan(dp);
dp(idx)=[];
delay(idx)=[];
idx=isinf(dp);
dp(idx)=[];
delay(idx)=[];
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