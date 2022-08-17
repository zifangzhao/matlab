%% 整合channel_def和计算结果,生成collected_data,collected_data=channelrearrange(rat_montage)
% 2013-2-2 revised by zifang zhao 修正了读取通道定义文件的问题
% 2012-12-10 revised by zifang zhao 本地保存文件再读取
% 2012-7-9  revised by Zifang Zhao 整合了修正旧版npcmi结果的功能
% 2012-6-16 revised by Zifang Zhao 取消了输出结果中所有原结果被归入.data属性的功能，保持数据结构
% 2012-4-15 revised by Zifang Zhao 当存在通道定义时跳过读取rawdata的步骤
% 2012-4-5  revised by Zifang zhao 修正了文件夹选择问题
% 2012-4-4  revised by Zifang zhao 函数版
% 2012-3-26 revised by Zifang zhao 更改montage为rat_montage
% 2012-3-24 revised by Zifang zhao
function collected_data=channelrearrange(rat_montage)

multiWaitbar('Close all');
%% 输入参数
def={'''raw'''...
    '[''analyzed'']'...
    'rat'};
answer=inputdlg({'Search keyword of raw data: [''a'';''b'';...]'...
    'Search keyword of the distributed analyzed data: [''pcmi'' ''slike'']'...
    'Search keyword of rat Directory: [rat]'},'Input parameters',1,def);

idx=1;
eval(['searchrawname={' answer{idx} '};']);idx=idx+1;
eval(['searchattrtemp={' answer{idx} '};']);idx=idx+1;
searchdirname=answer{idx};idx=idx+1;

searchattrname=cell(1,length(searchattrtemp));
for idx=1:length(searchattrtemp)
    searchattrname{idx}.name=searchattrtemp{idx};
    answer=inputdlg({'Please input data names need to be extract:(''Ixy'',''Iyx'','' '' for all data)'},['Distributed data keyword: ' searchattrtemp{idx}]);
    eval(['searchattrname{' num2str(idx) '}.dataname=answer{1};']);
end

multiWaitbar('Steps:',1/3,'Color',[0.8 0 0.8]);


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
str={names.name};
[s,v] = listdlg('PromptString','Select sub-folders',...
                'SelectionMode','multiple',...
                'ListString',str);
selected=str(s);
clear('str','s','v');


% 读取RAW DATA,保存通道定义
for d1=1:length(selected)
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    cd(selected{d1});%打开第一层文件夹,按RatXX编号
    matfile=[];
    for matnames=1:length(searchrawname)
        matfile=[matfile dir(['*' searchrawname{matnames} '*.mat'])];
    end
    for m=1:length(matfile)
        attr_idx=find(matfile(m).name=='_');
        if isempty(dir([matfile(m).name(1:attr_idx(end)) 'channeldef.mat']))
            system(['copy "' pwd '\' matfile(m).name '" c:\']);
            cwd=pwd;
            cd('c:\');
            rawdata=load(matfile(m).name);
            system(['del ' matfile(m).name]);
            cd(cwd);
            %             ratnumber=numfinder(matfile(i).name,'Rat');
            chans=chans_classify(matfile(m).name,rawdata,rat_montage,'elec');
            
            %         delete([matfile(i).name(1:end-length(searchname)-3) 'channeldef']);
            save([matfile(m).name(1:attr_idx(end)) 'channeldef'],'-struct','chans');
        end
    end

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
            system(['copy "' pwd '\' matfile(mat).name '" c:\']);
            cwd=pwd;
            cd('c:\');
            if isempty(searchattrname{matnames}.dataname)   %检查是否之前输入了特定需要提取的变量名
                %                 collected_data{idx}=load(matfile(mat).name);
                temp=load(matfile(mat).name);
                %                 eval(['collected_data{' num2str(idx) '}=load(matfile(' num2str(mat) ').name);']);
            else
                eval(['temp=load(matfile(' num2str(mat) ').name,' searchattrname{matnames}.dataname ');']);
            end
            system(['del ' matfile(mat).name]);
            cd(cwd);
            if isempty(strfind(fieldnames(temp),'Ixy'))
                collected_data{idx}=temp;clear('temp');
            else
                collected_data{idx}=reformat_nonstruct_pcmi(temp,200,3,6);clear('temp');
            end
            
            collected_data{idx}.name=matfile(mat).name;
            attr_loc=strfind(matfile(mat).name,searchattrname{matnames}.name);
            matfile_channeldef=[]; %dir([matfile(mat).name(1:attr_loc-2) '*channeldef*']);
            attr_idx=attr_loc-1;
            while isempty(matfile_channeldef)
                attr_idx=attr_idx-1;
                if attr_idx<0
                    errordlg('Please put raw data files in dictionary!','File Error');
                    return
                end
                matfile_channeldef=dir([matfile(mat).name(1:attr_idx) '*channeldef*']);
            end
            if isstruct(matfile_channeldef)
                collected_data{idx}.channeldef=load(matfile_channeldef.name);
            else
                collected_data{idx}.channeldef=load(matfile_channeldef);
            end
        end
    end
    cd('..')
end

multiWaitbar('Steps:',1,'Color',[0.8 0 0.8]);
multiWaitbar('Closeall');
end