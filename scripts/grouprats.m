%% 输入参数
groupC=[5 8 11 15 16 17];
groupEA=[4 6 7 12 13 14];
answer=inputdlg({'Search keyword of the distributed analyzed data: ''formalin'' ''slike'' ' 'Search keyword of rat Directory: rat'},'Input parameters');
searchdirname=answer{2};
eval(['searchrawname={' answer{1} '};']);
%% 第一级目录筛选，并提取序号
names=dir(['*' searchdirname '*.']); %查找所有文件夹
str={names.name};
[s,v] = listdlg('PromptString','Select data fieldnames',...
    'SelectionMode','multiple',...
    'ListString',str);
selected=str(s);
clear('str','s','v');
errnum=0;
collected_data=cell(length(selected),length(searchrawname));
for d1=1:length(selected)
    cd(selected{d1});%打开第一层文件夹,按RatXX编号
    
    matfile=[];
    for matnames=1:length(searchrawname)
        matfile=dir(['*' searchrawname{matnames} '*.mat']);
        for file=1:length(matfile)
%             tempfile=load(matfile(file).name);
%             delete(matfile(file).name);
%             SL=tempfile.SL;
            if isempty(find(groupC==numfinder(matfile(file).name,'Rat'), 1))
                if isempty(find(groupEA==numfinder(matfile(file).name,'Rat'), 1))
                else
                    system(['rename ' matfile(file).name ' ' matfile(file).name(1:end-4) '_EA.mat']);
%                     save([matfile(file).name(1:end-4) '_EA'],'SL');
                end
            else
                system(['rename ' matfile(file).name ' ' matfile(file).name(1:end-4) '_CTRL.mat']);
%                 save([matfile(file).name(1:end-4) '_CTRL'],'SL');
            end
        end
        
    end
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    cd('..');
end
% collected_data=reshape(collected_data,1,[]);
multiWaitbar('Closeall');

