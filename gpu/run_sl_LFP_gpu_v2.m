%run SL for laser files
function run_sl_LFP_gpu_v2()
%revised by zifang zhao @ 2012-6-20 优化查找文件夹功能，去掉resampling选项
% isOpen = matlabpool('size') ;
% if isOpen< 2
% %     matlabpool
% end
tic;
% searchdirname='rat';
%% 输入分组定义
def={'rat',...
    'raw',...
    '1000',...%     '100',...
    '[1,4,8,13,31]',...
    '[3,7,12,30,50]',...
    '10',...
    '0.05',...
    '[1:50]',...
    '[1:50]'...
    'youremail@email.com'};
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search rawdata keyword: e.g. raw' ...
    'Sampling rate(Hz):' ...%     'Resampling rate(Hz):' ...
    'Low pass filter(Hz:step:Hz):' ...
    'High stop filter(Hz:step:Hz):' ...
    'n_rec: (default:10)' ...
    'p_ref: (default:0.05)' ...
    'startpoints:' ...
    'delays:'...
    'email_address(for notification)'},'Synlike Calculating Parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
rawdata_name=answer{idx};idx=idx+1;
system_fs=str2double(answer{idx});idx=idx+1;
% res_fs=str2double(answer{idx});  idx=idx+1; 
LP=eval(answer{idx});idx=idx+1;
HS=eval(answer{idx});idx=idx+1;
n_rec=str2double(answer{idx});idx=idx+1;
p_ref=str2double(answer{idx});idx=idx+1;
stps=eval(answer{idx});idx=idx+1;
delays=eval(answer{idx});idx=idx+1;
email_address=answer{idx};idx=idx+1;
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
%     try
        general_sl_multidelay_gpu_v2(rawdata_name,system_fs,LP,HS,n_rec,p_ref,stps,delays);
%     catch err
%         err_idx=err_idx+1;
%         joberror{err_idx}=err;
%     end
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
    email_notify({email_address},title,[content 10 time_report],{[]});
else
    save('err_report.mat.rename','joberror');
    email_notify({email_address},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
end
