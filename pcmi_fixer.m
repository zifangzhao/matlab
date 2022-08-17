%% 原始pcmi重新整理，加入delay、扩充channel
% 2012-4-21 revised by Zifang Zhao 根据采样率修正delay
% 2012-4-4 revised by zifang zhao 函数版
function collected_data_fixed=pcmi_fixer(rat_montage,collected_data,fs)
% [filename pathname]=uigetfile('*.mat','Select rat_montage definition');
% load([pathname filename]);    %rat_montage
% [filename pathname]=uigetfile('*.mat','Select collected PCMI data');
% load([pathname filename]);    %collected_data
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
        collected_data_fixed{idxd}.data.Ixys=[];
        collected_data_fixed{idxd}.data.Iyxs=[];
        collected_data_fixed{idxd}.data.delay=[];
    else
        collected_data_fixed{idxd}.data.Ixys=cell(1,length(collected_data{idxd}.data.Ixys));
        collected_data_fixed{idxd}.data.Iyxs=cell(1,length(collected_data{idxd}.data.Iyxs));
        collected_data_fixed{idxd}.data.delay=cell(1,length(collected_data{idxd}.data.Ixys));
    end
    for trial=1:length(collected_data{idxd}.data.Ixys);
%         multiWaitbar('Trials:',trial/length(collected_data{idxd}.data.Ixys),'color',[0.2 0.75 0.37]);
        collected_data_fixed{idxd}.data.Ixys{trial}=cell(length(channel_all));
        collected_data_fixed{idxd}.data.Iyxs{trial}=cell(length(channel_all));
        collected_data_fixed{idxd}.data.delay{trial}=cell(length(channel_all));
        for ch_a=1:length(collected_data{idxd}.channeldef.def)
%             multiWaitbar('Channel1:',ch_a/length(collected_data{idxd}.channeldef.def),'color',[0.6 0.3 0.9]);
            for ch_b=1:length(collected_data{idxd}.channeldef.def)
%                 multiWaitbar('channel2:',ch_b/length(collected_data{idxd}.channeldef.def),'color',[0.5 0.5 0.5]);
                Ixys_temp=collected_data{idxd}.data.Ixys{trial}{ch_a,ch_b};
                Iyxs_temp=collected_data{idxd}.data.Iyxs{trial}{ch_a,ch_b};
                if(isempty(Ixys_temp));
                else
                    x=collected_data{idxd}.channeldef.def(ch_a);
                    y=collected_data{idxd}.channeldef.def(ch_b);
                    x=find(channel_all==x);
                    y=find(channel_all==y);
                    collected_data_fixed{idxd}.data.Ixys{trial}{x,y}=Ixys_temp;
                    collected_data_fixed{idxd}.data.Iyxs{trial}{x,y}=Iyxs_temp;
                    collected_data_fixed{idxd}.data.delay{trial}{x,y}=(1:length(collected_data_fixed{idxd}.data.Ixys{trial}{x,y}))./fs*1000;
                end
            end
        end
    end
end
% collected_data=collected_data_fixed;
% save([filename(1:end-4) '_fixed'],'collected_data');
end