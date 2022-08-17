%run SL for laser files
function run_shit_clean()
% revised by zifang zhao @ 2012-12-20 增加输入level,用于噪音筛除电平(abs)
%revised by zifang zhao @ 2012-12-5 增加分辨率限制
%revised by zifang zhao @ 2012-6-20 优化查找文件夹功能，去掉resampling选项
%revised by zifang zhao @ 2012-9-5 将stp,delay改为毫秒单位
isOpen = matlabpool('size') ;

tic;
% searchdirname='rat';
%% 输入分组定义
def={'rat',...
    'raw',...
    };
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search rawdata keyword: e.g. raw' ...
    },'Sheet clean Parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
rawdata_name=answer{idx};idx=idx+1;

clear('answer','groupingidx');

multiWaitbar('close all');
%% 目录筛选，并提取序号
names=dir(['*' searchdirname '*.']); %查找所有文件夹
while isempty(names)
    button=questdlg('Selected folder is not the container folder,reselect?','Please check!');
    switch button
        case 'Yes'
            cd(uigetdir(pwd,'Please reselect container folder location'));
            names=dir(['*' searchdirname '*.']);
        case 'No'
            return
        case 'Cancel'
            return
    end
end
multiWaitbar('Directorys:',0,'color',[0.8 0.8 0])
str={names.name};
[s,~] = listdlg('PromptString','Select directories',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str(s);
clear('str','s');
err_idx=0;
joberror=[];
for dir_idx=1:length(selected)
    
    cd(selected{dir_idx});
    
    files=dir('*.xls');
    for idx=1:length(files)
        data=xlsread(files(idx).name,'post');
        system(['del ' files(idx).name]);
        xlswrite(files(idx).name,data,'post');
        sheet123cleaner(files(idx).name,pwd);
    end

    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end
sch = findResource('scheduler','configuration',  defaultParallelConfig);
[hh mm ss]=timedisp(toc);
time_report=['总共用时:' num2str(hh) '小时' num2str(mm) '分钟' num2str(ss) '秒 @ ' datestr(now)];
fprintf(2,[time_report '\n']);

title=['Report from ' sch.Configuration ': SL complete!'];

content=['Job done!'];
% if(isempty(joberror))
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
% else
%     save('err_report.mat.rename','joberror');
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
% end
