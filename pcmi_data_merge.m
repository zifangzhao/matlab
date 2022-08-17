%% Merging all rats' data into same one, with different phase
function pcmi_all=pcmi_data_merge(pcmi_data,channel)
chan_size=length(channel.channel_map);
pcmi_all=cell(1,size(pcmi_data,2));
for phase=1:size(pcmi_data,2)
    pcmi_all{phase}.Ixy_delay{1}=cell(chan_size);
    pcmi_all{phase}.Iyx_delay{1}=cell(chan_size);
%     pcmi_all{phase}.delay{1}=cell(chan_size);
%     pcmi_all{phase}.DP_indexs{1}=zeros(chan_size);
%     pcmi_all{phase}.DP_index_mean{1}=zeros(chan_size);
%     pcmi_all{phase}.Ixy_max{1}=zeros(chan_size);
%     pcmi_all{phase}.Iyx_max{1}=zeros(chan_size);

end


%% Merging all rats' data into same one, with different phase
for rat=1:size(pcmi_data,1)
    for phase=1:size(pcmi_data,2)
        name=pcmi_data{rat,phase}.name;
        rat_num=numfinder(name,'rat');
        namloc=strfind(name,'formalin');
        pcmi_all{phase}.name=name(namloc:end-4);
        if(isempty(pcmi_data{rat,phase}.Ixys))
        else
            channel_size=size(pcmi_data{rat,phase}.Ixys{1});
            
            %% 找出对应编号动物的通道定义
            for m=1:length(channel.channel)
                num=numfinder(channel.channel{m}.name,'rat');
                if(num==rat_num)
                    chan_idx=m;  %通道列表中的索引
                end
            end
%             pcmi_all{phase}.DP_indexs=zeros(chan_size);
%             pcmi_all{phase}.DP_index_mean=zeros(chan_size);
%             pcmi_all{phase}.Ixy_max=zeros(chan_size);
%             pcmi_all{phase}.Iyx_max=zeros(chan_size);
            for ch_a=1:channel_size(1)
                for ch_b=1:channel_size(2)
                    x=channel.channel{chan_idx}.def(ch_a);
                    y=channel.channel{chan_idx}.def(ch_b);
                        %remapping channel index to 1:chan_size
                    y=find(channel.channel_map==y);
                    if(isempty(pcmi_data{rat,phase}.Ixys{1}{ch_a,ch_b})||isempty(pcmi_data{rat,phase}.Iyxs{1}{ch_a,ch_b}))
                    else
                        [Xmax Ymax XYmax]=pcmi_analysis(pcmi_data{rat,phase}.Ixys{1}{ch_a,ch_b},pcmi_data{rat,phase}.Iyxs{1}{ch_a,ch_b});
                        pcmi_all{phase}.Ixy_delay{1}{x,y}=[pcmi_all{phase}.Ixy_delay{1}{x,y}; Xmax.Ixy Xmax.delay];
                        pcmi_all{phase}.Iyx_delay{1}{x,y}=[pcmi_all{phase}.Iyx_delay{1}{x,y}; Ymax.Iyx Ymax.delay];
                        %                     pcmi_all{phase}.delay{1}{x,y}=[pcmi_all{phase}.delay{1}{x,y},1:length(pcmi_data{rat,phase}.Ixys{1}{ch_a,ch_b})];
                    end
                end
            end
        end
    end
end