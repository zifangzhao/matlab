%%rat_montage creater 2012-3-24 by zifang zhao
function rat_montage=montagecreater()
%% 2012-4-21 revised by Zifang Zhao 将输出变为mtg后缀
%% 2012-3-26 将montage改为rat_montage
%% 输入分组定义

answer=inputdlg({'Channel grouping name list: e.g. ''Cg1'' ''OFC''','Channel number in raw data: e.g. [1 2 3] [4 5 6]' 'rat_montage file name:'},'rat_montage Creater');
eval(['names={' answer{1} '};']);
eval(['channel={' answer{2} '};']);
filename=answer{3};
channel_all=sort([channel{:}]);

for idx=1:length(names)
    rat_montage{idx}.channel=channel{idx};
    rat_montage{idx}.name=names{idx};
    for chan=1:length(channel{idx})
        rat_montage{idx}.channelNo(chan)=find(channel_all==channel{idx}(chan));
    end
end
save([filename '.mtg'],'rat_montage')
clear('answer');