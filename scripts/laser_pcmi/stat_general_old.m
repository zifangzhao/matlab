%% statistical analysis of PCMI data

[filename pathname]=uigetfile('*.mat','Select montage definition');
load([pathname filename]);    %montage

[filename pathname]=uigetfile('*.mat','Select grouped PCMI data');
load([pathname filename]);    %grouped

channel_all=[];
for m=1:length(montage)
    channel_all=[channel_all montage{m}.channel];
end

% %% merge Ixy,Iyx and delay to Ixy_delay ,Iyx_delay 为了和原程序匹配
% for group=1:length(grouped_data)
%     grouped_combined_data{group}.Ixy_delay{1}=cellfun(@matrix_merge_vertical,grouped_data{group}.data.Ixys,grouped_data{group}.data.delay,'UniFormOutput',false);
%     grouped_combined_data{group}.Iyx_delay{1}=cellfun(@matrix_merge_vertical,grouped_data{group}.data.Iyxs,grouped_data{group}.data.delay,'UniFormOutput',false);
% end
%% region vs region
for group1=1:length(grouped_data)
    for group2=group1:length(grouped_data);

        for region1=1:length(montage)
            for region2=region1:length(montage)
                channel_mask=zeros(length(channel_all));
                channel_mask(montage{region1}.channel,montage{region2}.channel)=1;
                
                [t_test ks_test]=pcmi_region_stat(grouped_combined_data{group1},grouped_combined_data{group1},channel_mask,channel_mask,[grouped_data{group1}.attrname{1} '_' montage{region1}.name '_' montage{region2}.name],'A','A');
                t_test_Ixy(group1,region1,region2)=t_test.Ixy;
                t_test_Iyx(group1,region1,region2)=t_test.Iyx;
                t_test_Ixy_delay(group1,region1,region2)=t_test.Ixy_delay;
                t_test_Iyx_delay(group1,region1,region2)=t_test.Iyx_delay;
                ks_test_Ixy(group1,region1,region2)=ks_test.Ixy;
                ks_test_Iyx(group1,region1,region2)=ks_test.Iyx;
                ks_test_Ixy_delay(group1,region1,region2)=ks_test.Ixy_delay;
                ks_test_Iyx_delay(group1,region1,region2)=ks_test.Iyx_delay;
            end
        end
    end
end
close all;

