%run SL for laser files
function run_sl_LFP_gpu()
% revised by zifang zhao @ 2012-12-20 ��������level,��������ɸ����ƽ(abs)
%revised by zifang zhao @ 2012-12-5 ���ӷֱ�������
%revised by zifang zhao @ 2012-6-20 �Ż������ļ��й��ܣ�ȥ��resamplingѡ��
% isOpen = matlabpool('size') ;
% if isOpen< 2
% %     matlabpool
% end
tic;
% searchdirname='rat';
%% ������鶨��
def={'rat',...
    'raw',...
    '1000',...%     '100',...
    '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49]'...%'[1,4,8,13,31]',...%    
    '[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50]'...%'[3,7,12,30,50]',...
    '10',...
    '0.05',...
    '[-1000 3000]',...
    '[0 500]'...
    '1000'...
    '2e6'...
    'youremail@email.com'};
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search rawdata keyword: e.g. raw' ...
    'Sampling rate(Hz):' ...%     'Resampling rate(Hz):' ...
    'Low pass filter(Hz:step:Hz):' ...
    'High stop filter(Hz:step:Hz):' ...
    'n_rec: (default:10)' ...
    'p_ref: (default:0.05)' ...
    'starttime_range([start end] ms):' ...
    'delay_range([start end] ms):'...
    'max steps of time-shifting (steps):'...
    'Noise elimination level (nV):'...
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
max_steps=str2double(answer{idx});idx=idx+1;
n_level=str2double(answer{idx});idx=idx+1;
email_address=answer{idx};idx=idx+1;
clear('answer','groupingidx');

multiWaitbar('close all');
%% Ŀ¼ɸѡ������ȡ���
names=dir(['*' searchdirname '*.']); %���������ļ���
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

[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
if((filename)==0)
    warndlg('Please select a rat_montage file!','!! Warning !!')
    return
else
    load([pathname filename],'-mat');
end
skipall=0;
for dir_idx=1:length(selected)
    
    cd(selected{dir_idx});
%     try
        skipall=general_sl_multidelay_gpu(rawdata_name,system_fs,LP,HS,n_rec,p_ref,stps,delays,max_steps,n_level,rat_montage,skipall);
%     catch err
%         err_idx=err_idx+1;
%         joberror{err_idx}=err;
%     end
    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end
% sch= parcluster(parallel.defaultClusterProfile);
sch = findResource('scheduler','configuration', parallel.defaultClusterProfile);
[hh mm ss]=timedisp(toc);
time_report=['�ܹ���ʱ:' num2str(hh) 'Сʱ' num2str(mm) '����' num2str(ss) '�� @ ' datestr(now)];
fprintf(2,[time_report '\n']);

title=['Report from ' sch.Configuration ': SL complete!'];

content=['Job done!'];
if ~isequal(email_address,'youremail@email.com')
    if(isempty(joberror))
        email_notify({email_address},title,[content 10 time_report],{[]});
    else
        save('err_report.mat.rename','joberror');
        email_notify({email_address},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
    end
end