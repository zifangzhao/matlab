%% 整合channel_def和pcmi,生成collected_data
%%2012-3-24 Zifang zhao
%% pre-definition
% montage{1}.channel=[5,6,7,8,9,10,11,12];
% montage{1}.name='Cg1';
% montage{2}.channel=[17,18,19,20,21,22,23,24];
% montage{2}.name='OFC';
% montage{3}.channel=[25,26,27,28,29,30,31,32];
% montage{3}.name='S1';
% montage{4}.channel=[53,54,55,56,57,58,59,60];
% montage{4}.name='PAG';
[filename pathname]=uigetfile('*.mat','Select montage definition');
if((filename)==0)
    warndlg('Please select a montage file!','!! Warning !!')
end
load([pathname filename]);
clear('filename','pathname')
multiWaitbar('Close all');
%% 输入参数
answer=inputdlg({'Search keyword of raw data: [''a'';''b'';...]' 'Search keyword of the distributed analyzed data: [''pcmi'' ''slike'']' 'Search keyword of rat Directory: [rat]'},'Input parameters');
searchdirname=answer{3};
eval(['searchattrtemp={' answer{2} '};']);
eval(['searchrawname={' answer{1} '};']);

searchattrname=cell(1,length(searchattrtemp));
for idx=1:length(searchattrtemp)
    searchattrname{idx}.name=searchattrtemp{idx};
    answer=inputdlg({'Please input data names need to be extract:(''Ixy'',''Iyx'',none for all data)'},['Distributed data keyword: ' searchattrtemp{idx}]);
    eval(['searchattrname{' num2str(idx) '}.dataname=answer{1};']);
end
% clear('answer','searchattrtemp')
%     eval(['grouping={' grouping '}']);
multiWaitbar('Steps:',1/3,'Color',[0.8 0 0.8]);
%% 初始化
% days=cell(1,length(matfile));
% chans=days;

%% 目录筛选，并提取序号

names=dir(['*' searchdirname '*.']); %查找所有文件夹
str={names.name};
[s,v] = listdlg('PromptString','Select data fieldnames',...
                'SelectionMode','multiple',...
                'ListString',str);
selected=str(s);
clear('str','s','v');
% index=zeros(1,length(names));
% selected=cell(1,length(names));
% for m=1:length(names)
%     selected{m}=[names(m).name];
%     temp=(selected{m}(end-1:end));
%     if(strcmp(temp(1),'t'))
%         index(m)=str2double(temp(2));
%     else
%         index(m)=str2double(temp);
%     end
% end

% 读取RAW DATA,保存通道定义
for d1=1:length(names)
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    cd(selected{d1});%打开第一层文件夹,按RatXX编号
    matfile=[];
    for matnames=1:length(searchrawname)
        matfile=[matfile dir(['*' searchrawname{matnames} '*.mat'])];
    end
    for m=1:length(matfile)
        rawdata=load(matfile(m).name);
        %             ratnumber=numfinder(matfile(i).name,'Rat');
        chans=chans_classify(matfile(m).name,rawdata,montage);
        attr_idx=find(matfile(m).name=='_');
%         delete([matfile(i).name(1:end-length(searchname)-3) 'channeldef']);
        save([matfile(m).name(1:attr_idx(end)) 'channeldef'],'-struct','chans');
    end
%     cwd=pwd;
%     temp=find(cwd=='\');
%     cwd=cwd(temp(end)+1:end);
%     clear('temp')
%     delete([cwd '.mat'])
    cd('..')
end
multiWaitbar('Steps:',2/3,'Color',[0.8 0 0.8]);
%% 读取Distributed data,保存至根目录
idx=0;
for d1=1:length(selected)
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    cd(selected{d1});%打开第一层文件夹,按RatXX编号
    for matnames=1:length(searchattrname)
        matfile=dir(['*' searchattrname{matnames}.name '*.mat']);
        for mat=1:length(matfile)
            idx=idx+1;
        end
    end
    cd('..')
end
collected_data=cell(1,idx);
idx=0;

for d1=1:length(selected)
    cd(selected{d1});%打开第一层文件夹,按RatXX编号
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    for matnames=1:length(searchattrname)
        matfile=dir(['*' searchattrname{matnames}.name '*.mat']);
        for mat=1:length(matfile)
            idx=idx+1;
            eval(['collected_data{' num2str(idx) '}.data=load(matfile(' num2str(mat) ').name,' searchattrname{matnames}.dataname ');']);
            collected_data{idx}.name=matfile(mat).name;
            attr_loc=strfind(matfile(mat).name,searchattrname{matnames}.name);
            matfile_channeldef=dir([matfile(mat).name(1:attr_loc-2) '*channeldef*']);
            collected_data{idx}.channeldef=load(matfile_channeldef.name);
        end
    end
    cd('..')
end

cwd=pwd;
temp=find(cwd=='\');
cwd=cwd(temp(end)+1:end);
clear('temp')
save([cwd '_all'],'collected_data');
multiWaitbar('Steps:',1,'Color',[0.8 0 0.8]);