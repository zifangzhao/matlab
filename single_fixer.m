function collected_data=single_fixer(rat_montage,collected_data)
%% 扩充channel,使所有结果与montage中的通道定义相同
%created by zifang zhao@ 2013-2-2 based on the Npcmi_fixer
channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];
end
chan_size=length(channel_all);
multiWaitbar('Close all');
% collected_data_fixed=cell(1,length(collected_data));
data_sub_name=[];
for idxd=1:length(collected_data)
    data_sub_name=[data_sub_name fieldnames(collected_data{idxd}.data)];
end
data_sub_name=unique(data_sub_name);%获得所选文件中的所有存在的延时结构
for idxd=1:length(collected_data)
    multiWaitbar('Files:',idxd/length(collected_data),'color',[0.8 0.8 0]);
    %     collected_data_fixed{idxd}.name=collected_data{idxd}.name;
    %     if ~isempty(collected_data{idxd}.data)
    % %         collected_data_fixed{idxd}.data.Ixys=cell(1,length(collected_data{idxd}.data.Ixys));
    %
    %     end
    for sub_data_idx=1:length(data_sub_name)
        data=getfield(collected_data{idxd}.data,data_sub_name{sub_data_idx});
        for trial=1:length(data);
            %         multiWaitbar('Trials:',trial/length(collected_data{idxd}.data.Ixys),'color',[0.2 0.75 0.37]);
            %         collected_data_fixed{idxd}.data.Ixys{trial}=cell(length(channel_all));
            
            temp=cell(chan_size,1);
            
            for ch_a=1:length(collected_data{idxd}.channeldef.def)
                %             multiWaitbar('Channel1:',ch_a/length(collected_data{idxd}.channeldef.def),'color',[0.6 0.3 0.9]);

                    %                 multiWaitbar('channel2:',ch_b/length(collected_data{idxd}.channeldef.def),'color',[0.5 0.5 0.5]);
                    sub_temp=data{trial}{ch_a};
                    
                    if(isempty(sub_temp));
                    else
                        x=collected_data{idxd}.channeldef.def(ch_a);

                        x=find(channel_all==x);

                        temp{x}=sub_temp;
                        %                     collected_data_fixed{idxd}.data.Ixys{trial}{x,y}=Ixys_temp;
                    end

            end
            data{trial}=temp;
%             collected_data{idxd}.data.Ixys{trial}=temp;
        end
        collected_data{idxd}.data=setfield(collected_data{idxd}.data,data_sub_name{sub_data_idx},data);
    end
end
% collected_data=collected_data_fixed;
% save([filename(1:end-4) '_fixed'],'collected_data');
end