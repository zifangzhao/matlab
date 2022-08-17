%run STFT for laser files
function run_stft_LFP()
% created by zifang zhao @ 2013-2-1 based on run_sl_LFP
isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
tic;
% searchdirname='rat';
%% 输入分组定义
def={'rat',...
    'raw',...
    '1000',...%     '100',...
    '5000'...
    '100'...
    '50'...
    '100'...
    '100'...
    '2e6'};
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search rawdata keyword: e.g. raw' ...
    'Sampling rate(Hz):' ...%     'Resampling rate(Hz):' ...
    'Time period(ms, for pre and post each)'...
    'Window length(datapoints):'...
    'Number of overlap datapoints:'...
    'NFFT(Datapoints)'...
    'Resampling frequency(Hz) Deciding the highest frequency you can see'...
    'Noise elimination level (nV):'},'Synlike Calculating Parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
rawdata_name=answer{idx};idx=idx+1;
system_fs=str2double(answer{idx});idx=idx+1;
time_to_cal=str2double(answer{idx});  idx=idx+1; 
window=str2double(answer{idx});idx=idx+1;
noverlap=str2double(answer{idx});idx=idx+1;
nfft=str2double(answer{idx});idx=idx+1;
res_fs=str2double(answer{idx});idx=idx+1;
n_level=str2double(answer{idx});idx=idx+1;
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
        general_stft(rawdata_name,system_fs,res_fs,time_to_cal,window,noverlap,nfft,n_level);
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
    email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
else
    save('err_report.mat.rename','joberror');
    email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
end
