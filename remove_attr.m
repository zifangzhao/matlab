function run_cluster_find()
% created by zifang zhao @ 2012-6-20

isOpen = matlabpool('size') ;
if isOpen< 2
%     matlabpool
end
tic;

def={'rat',...
    'sl',...
    'phase'...
    };
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search calculated data keyword: e.g. pcmi/sl' ...
    'Tags to be merged with upper level'...
    },'Cluster parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
data_name=answer{idx};idx=idx+1;
kwd_temp=answer{idx};idx=idx+1;

loc=strfind(kwd_temp,' ');
% idx=1;
if isempty(loc)
    kwd{1}=kwd_temp;
else
    loc=unique([1 loc length(kwd_temp)]);
    for idx=1:length(loc)-1
        kwd{idx}=kwd_temp(loc(idx):loc(idx+1));
    end
end

clear('answer','groupingidx');

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
[s,v] = listdlg('PromptString','Select directories',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str(s);
clear('str','s','v');
err_idx=0;
joberror=[];
for dir_idx=1:length(selected)
    
    cd(selected{dir_idx});
    files=dir(['*' data_name '*.mat']);
    for f_idx=1:length(files)
        loc=cell2mat(cellfun(@(kwd) (strfind(files(f_idx).name,kwd)),kwd,'UniformOutput',0));
        if ~isempty(loc)
            if strcmp(files(f_idx).name(loc(1)-1),'_')
                system(['rename ' files(f_idx).name ' ' files(f_idx).name(1:loc(1)-2) files(f_idx).name(loc(1):end)]);
            end
        end
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
if(isempty(joberror))
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
else
    save('err_report.mat.rename','joberror');
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
end




