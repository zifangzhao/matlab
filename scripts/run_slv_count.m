%script for hist all SL
%% �������
def={'''raw'''...
    '[''SL'']'...
    'rat'};
answer=inputdlg({'Search keyword of  data: [''a'';''b'';...]'...
    'Search keyword of the distributed analyzed data: [''pcmi'' ''slike'']'...
    'Search keyword of rat Directory: [rat]'},'Input parameters',1,def);

idx=1;
eval(['searchrawname={' answer{idx} '};']);idx=idx+1;
eval(['searchattrtemp={' answer{idx} '};']);idx=idx+1;
searchdirname=answer{idx};idx=idx+1;


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

SLV=[];

for d1=1:length(selected)
    cd(selected{d1});%�򿪵�һ���ļ���,��RatXX���
    multiWaitbar('Directory:',d1/length(selected),'color',[0.8 0.8 0]);
    
    matfile=dir(['*' searchattrtemp{1} '*.mat']);
   
    for mat=1:length(matfile)
        if isempty(strfind(matfile(mat).name,'analyzed'))
            idx=idx+1;
            temp=load(matfile(mat).name);
            SLV=[SLV  reshape(SLV_count(temp.data),1,[])];
        end
    end
    
    
    cd('..')
end

