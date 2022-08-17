function run_cluster_find()
% this function is gonna combined in N_stat, thus no longer used zifangzhao @2013-11-24
% created by zifang zhao @ 2012-6-20

isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
tic;

def={'rat',...
    'sl',...
    '15',...
    '0.98'...
    '0.2'...
    '95'...
    '0'...
    '1'};
answer=inputdlg({'Search directory keyword: e.g. rat' ...
    'Search calculated data keyword: e.g. pcmi/sl' ...
    'min area(datapoints for method=0):' ...%     'Resampling rate(Hz):' ... 
    'max eccencity(0-1 for method=0)' ...
    'thersold level(0-1)' ...
    'min percent(0-100%)' ...
    'need plot?(0 or 1 for method=0)'...
    'method(0 for cluster_find, 1 for loc_find)'},'Cluster parameters',1,def);
idx=1;
searchdirname=answer{idx};idx=idx+1;
data_name=answer{idx};idx=idx+1;
min_area=str2double(answer{idx});idx=idx+1;
max_ecc=str2double(answer{idx});idx=idx+1;
min_I=str2double(answer{idx});idx=idx+1;
min_percent=str2double(answer{idx});idx=idx+1;
plot_on=str2double(answer{idx});idx=idx+1;
cluster_method=str2double(answer{idx});idx=idx+1;
clear('answer','groupingidx');

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
[s,v] = listdlg('PromptString','Select directories',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str(s);
clear('str','s','v');
err_idx=0;
joberror=[];
for dir_idx=1:length(selected)
    
    cd(selected{dir_idx});
%     try
        general_cluster_find(data_name,min_area,max_ecc,min_I,min_percent,plot_on,cluster_method);
%     catch err
%         err_idx=err_idx+1;
%         joberror{err_idx}=err;
%     end
    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end
sch = findResource('scheduler','configuration',  defaultParallelConfig);
[hh mm ss]=timedisp(toc);
time_report=['�ܹ���ʱ:' num2str(hh) 'Сʱ' num2str(mm) '����' num2str(ss) '�� @ ' datestr(now)];
fprintf(2,[time_report '\n']);

title=['Report from ' sch.Configuration ': SL complete!'];

content=['Job done!'];
if(isempty(joberror))
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
else
    save('err_report.mat.rename','joberror');
%     email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
end




