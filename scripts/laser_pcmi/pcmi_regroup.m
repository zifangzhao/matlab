%% 将collected_PCMI整合分组，产生grouped_PCMI
%%2012-3-24 by Zifang zhao
% cwd=pwd;
% temp=find(cwd=='\');
% cwd=cwd(temp(end)+1:end);
multiWaitbar('Close all');


[filename pathname]=uigetfile('*.mat','Select montage definition');
load([pathname filename]);    %montage

[filename pathname]=uigetfile('*.mat','Select collected PCMI data');
load([pathname filename]);    %collected_data

channel_all=[];
for m=1:length(montage)
    channel_all=[channel_all montage{m}.channel];
end

%% 输入分组定义
answer=inputdlg({'Grouping keyword: e.g. ''ctrl'' ''pain'';''pre'' ''post'''},'Grouping keywords');
groupingidx=find(answer{1}==';');
if(answer{1}(end)==';')
else
    groupingidx=[groupingidx length(answer{1})];
end
group_start=1;
for idx=1:length(groupingidx)
    if(idx>1)
        group_start=groupingidx(idx-1);
    end
    eval(['grouping{' num2str(idx) '}={' answer{1}(group_start:groupingidx(idx)) '};'])
end
clear('answer','groupingidx');

%% 选择需要的数据
str = fieldnames(collected_data{1}.data);
[s,v] = listdlg('PromptString','Select data fieldnames',...
    'SelectionMode','multiple',...
    'ListString',str);
selected_attr=str(s);
clear('str','s','v');

%% 找出目标数据文件的分类,做出分类表
data_attr_map=cell(1,length(collected_data));
for idxd=1:length(collected_data)
    data_attr_map{idxd}=attr_extracter(collected_data{idxd}.name,'_');
end
group_map=nan(length(grouping),length(collected_data));
for idxd=1:length(collected_data)
    for idxg=1:length(grouping)
        for idxc=1:length(grouping{idxg})
            if(isempty(find(strcmp(data_attr_map{idxd},grouping{idxg}(idxc)), 1)))
            else
                group_map(idxg,idxd)=idxc;
                break;
            end
        end
    end
end
%% 产生所有可能选择的类别
length_all=1;
for idxg=1:length(grouping)
    length_all=length_all*length(grouping{idxg});
end
grouped_data=cell(1,length_all);
for group_idx=1:length_all;
    grouped_data{group_idx}.attr=zeros(length(grouping),1);
    mod_temp=group_idx;
    grouped_data{group_idx}.attrname=[];
    for idxg=length(grouping):-1:1
        grouped_data{group_idx}.attr(idxg)=1+mod(ceil(mod_temp)-1,length(grouping{idxg}));
        grouped_data{group_idx}.attrname{idxg}=grouping{idxg}(grouped_data{group_idx}.attr(idxg));
        mod_temp=(mod_temp/length(grouping{idxg}));
    end
end

%% 整合数据

for group_idx=1:length_all;
    multiWaitbar('Merging:',group_idx/length_all,'color',[0.5 0.8 0.3]);
    equal_temp=ones(1,length(collected_data));
    for idxg=1:length(grouping)
        equal_temp=equal_temp.*(group_map(idxg,:)==grouped_data{group_idx}.attr(idxg));
    end
    locs=find(equal_temp);
    for attr_idx=1:length(selected_attr);
        eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=cell(length(channel_all));']); %初始化data
        for loc=1:length(locs)
            eval(['trial_length=length(collected_data{locs(loc)}.data.' selected_attr{attr_idx} ');']);
            for trial=1:length(trial_length);
                eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=cellfun(@matrix_merge,grouped_data{group_idx}.data.' selected_attr{attr_idx} ',collected_data{locs(loc)}.data.' selected_attr{attr_idx} '{trial},''UniformOutput'',false);']);
            end
        end
    end
end

% for idxg=1:length(grouping)
%     for idxc=1:length(grouping{idxg})
%         %         group_idx=group_idx+1;
%         %         grouped_data{group_idx}.attr(idxg)=idxc; %取得此分类属性
%         %         %预处理，整理数据
%         %         %将同组数据整合
%         % %         data_loc=find(group_map(1,:)
%         %         for attr_idx=1:length(selected_attr);
%         %             for
%         %             grouped_data{group_idx}.data.Ixys=cellfun(@matrix_merge,grouped_data{group_idx}.data.Ixys,collected_data{1}.data.Ixys{2},'UniformOutput',false);
%         % %             eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=[];]')
%         %         end
%         %
%     end
% end
save([filename(1:end-4) '_grouped'],'grouped_data');