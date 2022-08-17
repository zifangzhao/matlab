function cluster_find_Npcmi()


isOpen = matlabpool('size') ;
if isOpen< 2
%     matlabpool
end
tic;

def={'rat',...
    'raw',...
    '15',...
    '0.98'...
    '0.2'...
    '95'...
    '0'};
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search calculated data keyword: e.g. raw' ...
    'min area(datapoints):' ...%     'Resampling rate(Hz):' ... 
    'max eccencity(0-1)' ...
    'thersold level(0-1)' ...
    'min percent(0-100%)' ...
    'need plot?(0 or 1)'},'Cluster parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
data_name=answer{idx};idx=idx+1;
min_area=str2double(answer{idx});idx=idx+1;
max_ecc=str2double(answer{idx});idx=idx+1;
min_I=str2double(answer{idx});idx=idx+1;
min_percent=str2double(answer{idx});idx=idx+1;
plot_on=str2double(answer{idx});idx=idx+1;

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
    try
        general_sl_multidelay(rawdata_name,system_fs,res_fs,LP,HS,n_rec,p_ref,stps,delays);
    catch err
        err_idx=err_idx+1;
        joberror{err_idx}=err;
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
    email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
else
    save('err_report.mat.rename','joberror');
    email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
end




locs=cell(trials,1);
stds=cell(trials,1);
for trial=1:trials
    I_merge=cellfun(@cell_merge,data.Ixys{trial},data.Iyxs{trial}','UniformOutput',0);  %将Ixys、Iyxs合成一个大矩阵
    locs{trial}=cell(size(I_merge));
    stds{trial}=cell(size(I_merge));
    [locs{trial} stds{trial}]=cellfun(@(x) cluster_find(x,min_area,max_ecc,min_I,min_percent,plot_on),I_merge,'UniformOutput',0);
end


pcmi.data=[];
pcmi.data.locs=locs;
pcmi.data.stds=stds;
end
function M=cell_merge(A,B)
M=[A,B];
end