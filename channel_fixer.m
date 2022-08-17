%% ���������������������montage�����õ�δ��¼��ͨ����ʹ�������һ�»�
% 2012-6-16 revised by Zifang zhao , ͨ�û���̣������޸�����ͨ����ʱ�ṹ������
% 2012-6-16 updated from pcmi_fixer
% 2012-4-21 revised by Zifang Zhao ���ݲ���������delay
% 2012-4-4 revised by zifang zhao ������
function collected_data_fixed=channel_fixer(rat_montage,collected_data)

channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];
end
chan_size=length(channel_all);
multiWaitbar('Close all');
collected_data_fixed=cell(1,length(collected_data));
for idxd=1:length(collected_data)
    multiWaitbar('Files:',idxd/length(collected_data),'color',[0.8 0.8 0]);
    collected_data_fixed{idxd}.name=collected_data{idxd}.name;
    if isempty(collected_data{idxd}.data)
        collected_data_fixed{idxd}.data=[];
    else
        attrs=fieldnames(collected_data_fixed{idxd}.data);
        for attr=1:length(attrs)
            eval(['attr_iscell=iscell(collected_data_fixed{idxd}.data.' attrs{attr} ');']);
            if attr_iscell
                eval(['collected_data_fixed{idxd}.data.' attrs{attr} '=cell(size(collected_data{idxd}.data.' attrs{attr} '));']); %cell�����ݽ���cell������
                eval(['trial_len=length(collected_data{idxd}.data.' attrs{attr} ');']);
                for trial=1:trial_len;
                    %         multiWaitbar('Trials:',trial/length(collected_data{idxd}.data.Ixys),'color',[0.2 0.75 0.37]);
                    eval(['collected_data_fixed{idxd}.data.' attrs{attr} '{trial}=cell(chan_size);']);

                    for ch_a=1:length(collected_data{idxd}.channeldef.def)
                        %             multiWaitbar('Channel1:',ch_a/length(collected_data{idxd}.channeldef.def),'color',[0.6 0.3 0.9]);
                        for ch_b=1:length(collected_data{idxd}.channeldef.def)
                            %                 multiWaitbar('channel2:',ch_b/length(collected_data{idxd}.channeldef.def),'color',[0.5 0.5 0.5]);
                            eval(['data_temp=collected_data{idxd}.data.' attrs{attr} '{trial}{ch_a,ch_b};'])

                            if(isempty(data_temp));
                            else
                                x=collected_data{idxd}.channeldef.def(ch_a);
                                y=collected_data{idxd}.channeldef.def(ch_b);
                                x= channel_all==x;
                                y= channel_all==y;
                                eval(['collected_data_fixed{idxd}.data.' attrs{attr} '{trial}{x,y}=data_temp;']);

                            end
                        end
                    end
                end
            else
                eval(['collected_data_fixed{idxd}.data.' attrs{attr} '=collected_data{idxd}.data.' attrs{attr} ';'])  %��cell��ֱ��ת��;
            end
        end
    end
    
end
% collected_data=collected_data_fixed;
% save([filename(1:end-4) '_fixed'],'collected_data');
end