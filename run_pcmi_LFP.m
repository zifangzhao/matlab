%run pcmi for laser files
function run_pcmi_LFP()

isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
tic;
% searchdirname='rat';
%% ������鶨��
answer=inputdlg({'Grouping keyword: e.g. ''ctrl'' ''pain'';''pre'' ''post''' 'Search directory keyword: e.g. ''rat''' 'Search rawdata keyword: e.g. ''raw''' 'Sampling rate(Hz):' 'Resampling rate(Hz):' 'tau:' 'ord:'},'Grouping keywords');
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
system_fs=str2double(answer{4});
res_fs=str2double(answer{5});
tau=str2double(answer{6});
ord=str2double(answer{7});
clear('answer','groupingidx');

multiWaitbar('close all');
%% Ŀ¼ɸѡ������ȡ���
names=dir(['*' searchdirname '*.']); %���������ļ���
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
%         ord=3;
%         tau=3;
        delta=ord*tau:res_fs/2;
        stps=delta;
        general_pcmi_LFP(rawdata_name,system_fs,res_fs,ord,tau,delta,stps);
    catch err
        err_idx=err_idx+1;
        error{err_idx}=err;
    end
    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end
sch = findResource('scheduler','configuration',  defaultParallelConfig);
[hh mm ss]=timedisp(toc);
time_report=['�ܹ���ʱ:' num2str(hh) 'Сʱ' num2str(mm) '����' num2str(ss) '�� @ ' datestr(now)];
fprintf(2,[time_report '\n']);
title=['Report from ' sch.name ': complete!'];
content=['Job done!'];
if(isempty(error))
    email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 time_report],{[]});
else
    save('err_report.mat.rename','error');
    email_notify({'aerocat@sina.com' 'bamboo.pku@gmail.com'},title,[content 10 'Some error occured while running scripts, please check the attachment.' 10 'Please rename the file to err_report.mat' 10 time_report],{'err_report.mat.rename'});
end
