%% 修正sl的startpoint 坐标
%% 输入分组定义
def={'rat',...
    'sl',...
    };
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search rawdata keyword: e.g. raw' ...
    },'Synlike Calculating Parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
searchkeyword=answer{idx};idx=idx+1;

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
    try
        matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
        multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);
        
        for file_idx=1:length(matfile)
            rawdata=load(matfile(file_idx).name);
            rawdata.startpoint=rawdata.startpoint-rawdata.w1;
            save(matfile(file_idx).name,'-struct','rawdata');
            
            multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
        end
    catch err
        err_idx=err_idx+1;
        joberror{err_idx}=err;
    end
    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end