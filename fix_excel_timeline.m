%script for change the pre-post timeline to post[-500 1500]ms mode
%% 输入分组定义

answer=inputdlg({'Search directory keyword: e.g. ''rat''' },'Grouping keywords',1,{'rat'});

searchdirname=answer{1};

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
        xls_file=dir(['*.xls']);
        for fle_idx=1:length(xls_file)
            [~,field_names,~]=xlsfinfo(xls_file(fle_idx).name);
            if sum(strcmp(field_names,'pre'))
                data=xlsread(xls_file(fle_idx).name,'post');
                data=data-0.5;
                system(['del ' xls_file(fle_idx).name]);
                xlswrite(xls_file(fle_idx).name,data,'postfix');
                sheet123cleaner(xls_file(fle_idx).name,pwd);
            end
            if sum(strcmp(field_names,'-500+1500'))
                data=xlsread(xls_file(fle_idx).name,'-500+1500');
                data=data-0.5;
                system(['del ' xls_file(fle_idx).name]);
                xlswrite(xls_file(fle_idx).name,data,'postfix');
                sheet123cleaner(xls_file(fle_idx).name,pwd);
            end

end
    catch err
        err_idx=err_idx+1;
        error{err_idx}=err;
    end
    cd('..')
    multiWaitbar('Directorys:',dir_idx/length(selected),'color',[0.8 0.8 0])
end
