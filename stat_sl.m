%% statistical analysis of PCMI data
function stat_sl()
% 2012-4-19 revised by Zifang Zhao  修改结果结构为tests.datatype.testtype.testvalues
% 2012-4-16 revised by Zifang Zhao  修正回归到原始目录，修正multiWaitbar进度提前问题
% 2012-4-15 created by Zifang Zhao, based on stat_pcmi
cwd=pwd;
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


%%  region vs region

dirname=[uigetdir '\'];

idx=0;
count=0;
multiWaitbar('Close all');
multiWaitbar('Data idx',0,'Color',[0.1 0.5 0.8]);
multiWaitbar('Dataset A',0,'Color',[0.2 0.5 0.5]);
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

                    SL1=grouped_data{group1}.data.SL;
                    SL2=grouped_data{group2}.data.SL;

                    att_len=length(grouped_data{group1}.attrname);
                    nameA=[];
                    nameB=[];
                    for n=1:att_len
                        try
                            nameA=[nameA '_' grouped_data{group1}.attrname{n}{:}];
                            nameB=[nameB '_' grouped_data{group2}.attrname{n}{:}];
                        catch err
                        end
                    end
                    count=count+1;
                    [t_test_current jobnew]=sl_region_stat(SL1,SL2,channel_mask,dirname,['SL ' nameA ' vs ' nameB '@' rat_montage{region1}.name ' ' rat_montage{region2}.name],sch);
                    jobhandle=[jobhandle jobnew];
%                     if count>500
%                         count=0;
%                         if isempty(jobhandle)
%                         else
%                             wait(jobhandle(end));
%                             for idx=1:length(jobhandle)
%                                 destroy(jobhandle(1));
%                                 jobhandle(1)=[];
%                             end
%                             
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
                    test_result{idx}.tests.SL.t_test.p=t_test_current.p;
                    test_result{idx}.tests.SL.t_test.t=t_test_current.t;
                    test_result{idx}.tests.SL.t_test.sd=t_test_current.sd;
%                     test_result{idx}.ks_test=ks_test_current;
%                     test_result{idx}.ks_curve=ks_curve;
                end
            end
            %             end
            multiWaitbar('Dataset B',compare_idxB/length(compare_idxsetB),'Color',[0.5 0.8 0.3]);
        end
        multiWaitbar('Dataset A',currentA/length(data_selectedA),'Color',[0.2 0.5 0.5]);
    end
    multiWaitbar('Data idx',compare_idxA/length(compare_idxsetA),'Color',[0.1 0.5 0.8]);
end
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
                        
cd(dirname);
% cd('..')
save([filename(1:end-4) '_result'],'test_result')

cd(cwd);
multiWaitbar('Closeall');
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