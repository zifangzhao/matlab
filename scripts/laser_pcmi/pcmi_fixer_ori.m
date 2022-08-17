%% 原始pcmi重新整理，加入delay、扩充channel
% 
[filename pathname]=uigetfile('*.mat','Select montage definition');
load([pathname filename]);    %montage
[filename pathname]=uigetfile('*.mat','Select collected PCMI data');
load([pathname filename]);    %collected_data
channel_all=[];
for m=1:length(montage)
    channel_all=[channel_all montage{m}.channel];
end
chan_size=length(channel_all);
multiWaitbar('Close all');
data_new=cell(1,length(collected_data));
for idxd=1:length(collected_data)
    multiWaitbar('Files:',idxd/length(collected_data),'color',[0.8 0.8 0]);
    data_new{idxd}.Ixys=cell(length(collected_data{idxd}.data.Ixys));
    data_new{idxd}.Iyxs=cell(length(collected_data{idxd}.data.Iyxs));
    data_new{idxd}.delay=cell(length(collected_data{idxd}.data.Ixys));
    for trial=1:length(collected_data{idxd}.data.Ixys);
%         multiWaitbar('Trials:',trial/length(collected_data{idxd}.data.Ixys),'color',[0.2 0.75 0.37]);
        data_new{idxd}.Ixys{trial}=cell(length(channel_all));
        data_new{idxd}.Iyxs{trial}=cell(length(channel_all));
        data_new{idxd}.delay{trial}=cell(length(channel_all));
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
                    data_new{idxd}.Ixys{trial}{x,y}=Ixys_temp;
                    data_new{idxd}.Iyxs{trial}{x,y}=Iyxs_temp;
                    data_new{idxd}.delay{trial}{x,y}=length(data_new{idxd}.Ixys{trial}{x,y});
                end
            end
        end
    end
end
collected_data=data_new;
save([filename(1:end-4) '_fixed'],'collected_data');