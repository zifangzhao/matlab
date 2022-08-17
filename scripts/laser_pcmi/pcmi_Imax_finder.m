%% pcmi Ixy Iyx max loc finder
%%2012-03-24 version  by Zifang Zhao , improved with pcmi_analysis_prc()
%%2012-03-24 version Zifang Zhao
isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
[filename pathname]=uigetfile('*.mat','Select montage definition');
load([pathname filename]);    %montage

[filename pathname]=uigetfile('*.mat','Select fixed  PCMI data');
% load([pathname filename]);    %

channel_all=[];
for m=1:length(montage)
    channel_all=[channel_all montage{m}.channel];
end
multiWaitbar('Close all');
collected_data2=cell(1,length(collected_data));
parfor idx=1:length(collected_data)
%     multiWaitbar('File idx',idx/length(collected_data),'Color',[0.2 0.2 0.8]);
    collected_data2{idx}.name=collected_data{idx}.name;
    collected_data2{idx}.data=collected_data{idx}.data;
    for trial=1:length(collected_data{idx}.data.Ixys);
%         multiWaitbar('Trial',trial/length(collected_data{idx}.data.Ixys));
        for ch_a=1:size(collected_data{idx}.data.Ixys{trial},1)
            for ch_b=1:size(collected_data{idx}.data.Ixys{trial},2)
                [Xmax Ymax]=pcmi_analysis_prc(collected_data{idx}.data.Ixys{trial}{ch_a,ch_b},collected_data{idx}.data.Iyxs{trial}{ch_a,ch_b},99.5);
                collected_data2{idx}.data.Xmax{trial}{ch_a,ch_b}=[Xmax.Ixy;Xmax.Iyx;Xmax.delay;Xmax.DP;];
                collected_data2{idx}.data.Ymax{trial}{ch_a,ch_b}=[Ymax.Ixy;Ymax.Iyx;Ymax.delay;Ymax.DP;];
            end
        end
    end
end
collected_data=collected_data2;
save([pathname filename(1:end-4) '_Imax'],'collected_data','-v7');