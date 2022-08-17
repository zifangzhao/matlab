%% ��collected_data���Ϸ��飬����grouped_data
% 2013-10-25 revised by zifang zhao add the ability to merge 2 diferent
% data types
% 2012-12-27 revised by zifang zhao ����trial_num�����Ϻ�ķ���������
% 2012-12-23 revised by zifang zhao ����trialΪ��ʱ����������,��ĳ�����в�����ֵ��ʱ��ɾ��֮
% 2012-10-31 revised by zifang zhao �������ϳ�data�������������������
% 2012-10-2 revised by zifang zhao ���������������⣬����matrix_v_merge����
% 2012-9-27 revised by zifang zhao �������Ϻ��data��ǩ�ļ���(unique)
% 2012-9-18 revised by zifang zhao �����Զ���ǩ��ѡ
% 2012-4-15 revised by Zifang Zhao ���ӶԶ༶��ǩ��֧��,�����ɾ���˴��ձ�ǩ����������
% 2012-4-14 renamed from pcmi_regroup
% 2012-4-15 revised by Zifang Zhao �������ձ�ǩ������
% 2012-4-14 revised by Zifang Zhao ���Ӷ�ĳ�����ݲ��߱�������ǩ������֧��
% 2012-4-13 revised by Zifang Zhao ����վ��󱨴�����
% 2012-4-10 revised by Zifang Zhao ���Ʒ����������ܣ�����attr_extractor
% 2012-4-4  revised by Zifang Zhao functionalized
% 2012-3-24 revised by Zifang zhao
%%����collected_data_all_fixed_Imax
function grouped_data=data_regroup(rat_montage,collected_data,mer_mode)
if nargin<3
    mer_mode=0;
end
multiWaitbar('Close all');
% cwd=pwd;
% temp=find(cwd=='\');
% cwd=cwd(temp(end)+1:end);

% [filename pathname]=uigetfile('*.mat','Select rat_montage definition');
% load([pathname filename]);    %rat_montage
% 
% [filename pathname]=uigetfile('*.mat','Select collected PCMI data');
% load([pathname filename]);    %collected_data

channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];
end
%% �ҳ�Ŀ�������ļ��ķ���,���������
data_attr_map=cell(1,length(collected_data));
for idxd=1:length(collected_data)
    data_attr_map{idxd}=attr_extracter(collected_data{idxd}.name,'_');
end%

tag_len=cellfun(@(x) length(x),data_attr_map);
for idx=1:max(tag_len)
    tag_map=tag_len>=idx;
    tags{idx}=unique(cellfun(@(x) x{idx},data_attr_map(tag_map),'UniformOutput',0));
    
end

%% ѡ���ǩ��
str = tags;
str=cellfun(@(x) [x{:}],str,'UniformOutput',0);
[s,v] = listdlg('PromptString','Select compare sets',...
    'SelectionMode','multiple',...
    'ListString',str);
% selected_tag=str(s);
sin_tag=s(s<=min(tag_len));
mul_tag=s(s>min(tag_len));
group_kwd=[];
for idx=1:length(sin_tag)-1
    for t_idx=1:length(tags{sin_tag(idx)})
        group_kwd=[group_kwd ' ''' tags{sin_tag(idx)}{t_idx} ''''];
    end
    group_kwd=[group_kwd ';'];
end
if ~isempty(mul_tag)
    choice=zeros(length(mul_tag),1);
    for idx=1:length(mul_tag)
        button = questdlg([tags(mul_tag(idx)) '��δ�����������о��д˷��࣬�Ƿ�ϲ���ǰ����'],'Merging tags','Yes','No','Yes');
        choice(idx)=strcmp(button,'Yes');
    end
    choice=[0 choice];
    zero_loc=find(choice==0);
    for idx=1:length(zero_loc)
        if idx<length(zero_loc)
            temp=find_name(data_attr_map,sin_tag(end)-1+zero_loc(idx):zero_loc(idx+1));
        else
            temp=find_name(data_attr_map,sin_tag(end)-1+zero_loc(idx):zero_loc(end));
        end
        group_kwd=[group_kwd temp];
    end
else
    for t_idx=1:length(tags{max(sin_tag)})
        group_kwd=[group_kwd ' ''' tags{sin_tag(end)}{t_idx} ''''];
    end
    group_kwd=[group_kwd ';'];
end
clear('str','s','v');
%% ������鶨��
answer=inputdlg({'Grouping keyword: e.g. ''ctrl'' ''pain'';''pre'' ''post'' �����Ҫ�༶��ǩ����_������༶��ǩ'},'Grouping keywords',1,{group_kwd});
groupingidx=find(answer{1}==';');
if(answer{1}(end)==';')  %������ķ�������޷ֺŵ�����
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

%% ѡ����Ҫ������
str = fieldnames(collected_data{1}.data);
[s,v] = listdlg('PromptString','Select data fieldnames',...
    'SelectionMode','multiple',...
    'ListString',str);
selected_attr=str(s);
clear('str','s','v');


group_map=nan(length(grouping),length(collected_data));
for idxd=1:length(collected_data)
    for idxg=1:length(grouping)
        group_map(idxg,idxd)=0; %���޴˱�ǩ���࣬������Ϊ0
        for idxc=1:length(grouping{idxg})   
            %2012-4-15 ���ӶԶ༶��ǩ��֧��
            grouping_list=attr_extracter(grouping{idxg}{idxc},'_');
            found=1;
            for mul_src_idx=1:length(grouping_list)
                if(isempty(find(strcmp(data_attr_map{idxd},grouping_list(mul_src_idx)), 1)))
                    %             if(isempty(strfind(collected_data{idxd}.name,grouping{idxg}{idxc})))
                    found=0;
                end
            end
            if found==1
                group_map(idxg,idxd)=idxc;
                break;
            end
        end
    end
end
%% Ϊgrouped_data�������п���ѡ������
length_all=1;
for idxg=1:length(grouping)
    length_all=length_all*(length(grouping{idxg}));
end
grouped_data=cell(1,length_all);
for group_idx=1:length_all;
    grouped_data{group_idx}.attr=zeros(length(grouping),1);
    mod_temp=group_idx;
    grouped_data{group_idx}.attrname=[];
    for idxg=length(grouping):-1:1
        grouped_data{group_idx}.attr(idxg)=1+mod(ceil(mod_temp)-1,length(grouping{idxg}));

            grouped_data{group_idx}.attrname{idxg}=grouping{idxg}(grouped_data{group_idx}.attr(idxg));
        
        mod_temp=(mod_temp/(length(grouping{idxg})));
        
    end
end

%% ��������
empty_grp=[];
for group_idx=1:length_all;
    multiWaitbar('Merging:',group_idx/length_all,'color',[0.5 0.8 0.3]);
    equal_temp=ones(1,length(collected_data));
    for idxg=1:length(grouping)
        equal_temp=equal_temp.*(group_map(idxg,:)==grouped_data{group_idx}.attr(idxg)); %���ݵ�ǰ����ķ����ǩ��ԭʼ�������ҳ��������������ݼ�
    end
    locs=find(equal_temp);
    for attr_idx=1:length(selected_attr);
        eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=cell(length(channel_all));']); %��ʼ��data
        trial_num=0;
        for loc=1:length(locs)
            eval(['trial_length=length(collected_data{locs(loc)}.data.' selected_attr{attr_idx} ');']);
            trial_num=trial_num+trial_length;
            if trial_length~=0
                for trial=1:length(trial_length);
                    eval(['trlempty=isempty(collected_data{locs(loc)}.data.' selected_attr{attr_idx} '{trial});']);
                    if trlempty==0
                        eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=cellfun(@(x,y) matrix_v_merge(x,y,mer_mode),grouped_data{group_idx}.data.'...
                            selected_attr{attr_idx} ',collected_data{locs(loc)}.data.' selected_attr{attr_idx} '{trial},''UniformOutput'',false);']);
                        
                    end
                end
            end
        end
        if mer_mode==1
            eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=grouped_data{group_idx}.data.' selected_attr{attr_idx} '/trial_num;'])
        end
        grouped_data{group_idx}.trial_num=trial_num;
    end
    if ~isempty(locs)   
        fld_sample=fieldnames(collected_data{locs(1)});
        for fld_idx=1:length(fld_sample)
            if ~strcmp(fld_sample(fld_idx),'data')
                if isnumeric(getfield(collected_data{locs(1)},fld_sample{fld_idx}))
                    eval(['grouped_data{group_idx}.' fld_sample{fld_idx} '=unique(cell2mat(arrayfun(@(x) x.' fld_sample{fld_idx} ',[collected_data{locs}],''UniformOutput'',0)));']);
                else
                    eval(['grouped_data{group_idx}.' fld_sample{fld_idx} '=(arrayfun(@(x) x.' fld_sample{fld_idx} ',[collected_data{locs}],''UniformOutput'',0));']);
                end
            end
        end
    else
        empty_grp=[empty_grp group_idx];
    end
end

if ~isempty(empty_grp)
    grouped_data(empty_grp)=[];
end


% for idxg=1:length(grouping)
%     for idxc=1:length(grouping{idxg})
%         %         group_idx=group_idx+1;
%         %         grouped_data{group_idx}.attr(idxg)=idxc; %ȡ�ô˷�������
%         %         %Ԥ������������
%         %         %��ͬ����������
%         % %         data_loc=find(group_map(1,:)
%         %         for attr_idx=1:length(selected_attr);
%         %             for
%         %             grouped_data{group_idx}.data.Ixys=cellfun(@matrix_merge,grouped_data{group_idx}.data.Ixys,collected_data{1}.data.Ixys{2},'UniformOutput',false);
%         % %             eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=[];]')
%         %         end
%         %
%     end
% end
% save([filename(1:end-4) '_grouped'],'grouped_data');
multiWaitbar('Closeall');
end

function mat=matrix_v_merge(matA,matB,mer_mode)
if mer_mode==0
    mat=[matA;matB];
else
    mat=matA+matB;
end
end
function group_kwd=find_name(data_attr_map,idx_range)
tag_len=arrayfun(@length,data_attr_map);
group_kwd=[];
for idx=1:length(idx_range)
    loc= tag_len==idx;
    tags=unique(cellfun(@(x) x{idx_range(1):idx_range(idx)},data_attr_map(loc),'UniformOutput',0));
    for tag_idx=1:length(tags)
        group_kwd=[group_kwd ' ''' tags{tag_idx} ''''];
    end
end
end