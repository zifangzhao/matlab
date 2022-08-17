%run pcmi for laser files
isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
tic;
% searchdirname='rat';
%% 输入分组定义
answer=inputdlg({'Grouping keyword: e.g. ''ctrl'' ''pain'';''pre'' ''post''' 'Search directory keyword: e.g. ''rat''' 'Search rawdata keyword: e.g. ''raw'''},'Grouping keywords');
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
searchdirname=answer{2};
rawdata_name=answer{3};
clear('answer','groupingidx');

multiWaitbar('close all');
%% 目录筛选，并提取序号
names=dir(['*' searchdirname '*.']); %查找所有文件夹
multiWaitbar('Directorys:',0,'color',[0.8 0.8 0])
str={names.name};
[s,v] = listdlg('PromptString','Select directories',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str(s);
clear('str','s','v');
err_idx=0;
error=[];
for dir_idx=1:length(selected)
    
    cd(selected{dir_idx});
    try
        general_pcmi_laser(rawdata_name,0.01,3,1,3:500);
    catch err
        err_idx=err_idx+1;
        error{err_idx}=err;
    end
    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end

[hh mm ss]=timedisp(toc);
time_report=['总共用时:' num2str(hh) '小时' num2str(mm) '分钟' num2str(ss) '秒 @ ' datestr(now)];
fprintf(2,[time_report '\n']);
title='Report from wanlab-LAB000: complete!';
content=['Job done!'];
% if(isempty(error))
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
% else
%     save('err_report.mat.rename','error');
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
% end
