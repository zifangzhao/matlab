%% ����channel_def�ͼ�����,����collected_data,collected_data=channelrearrange(rat_montage)
% 2013-2-2 revised by zifang zhao �����˶�ȡͨ�������ļ�������
% 2012-12-10 revised by zifang zhao ���ر����ļ��ٶ�ȡ
% 2012-7-9  revised by Zifang Zhao �����������ɰ�npcmi����Ĺ���
% 2012-6-16 revised by Zifang Zhao ȡ����������������ԭ���������.data���ԵĹ��ܣ��������ݽṹ
% 2012-4-15 revised by Zifang Zhao ������ͨ������ʱ������ȡrawdata�Ĳ���
% 2012-4-5  revised by Zifang zhao �������ļ���ѡ������
% 2012-4-4  revised by Zifang zhao ������
% 2012-3-26 revised by Zifang zhao ����montageΪrat_montage
% 2012-3-24 revised by Zifang zhao
function collected_data=channelrearrange(rat_montage)

multiWaitbar('Close all');
%% �������
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
str={names.name};
[s,v] = listdlg('PromptString','Select sub-folders',...
                'SelectionMode','multiple',...
                'ListString',str);
selected=str(s);
clear('str','s','v');


% ��ȡRAW DATA,����ͨ������
for d1=1:length(selected)
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    cd(selected{d1});%�򿪵�һ���ļ���,��RatXX���
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
%% ��ȡDistributed data,��������Ŀ¼
idx=0;
for d1=1:length(selected)
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    cd(selected{d1});%�򿪵�һ���ļ���,��RatXX���
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
    cd(selected{d1});%�򿪵�һ���ļ���,��RatXX���
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    for matnames=1:length(searchattrname)
        matfile=dir(['*' searchattrname{matnames}.name '*.mat']);
        for mat=1:length(matfile)
            idx=idx+1;
            system(['copy "' pwd '\' matfile(mat).name '" c:\']);
            cwd=pwd;
            cd('c:\');
            if isempty(searchattrname{matnames}.dataname)   %����Ƿ�֮ǰ�������ض���Ҫ��ȡ�ı�����
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