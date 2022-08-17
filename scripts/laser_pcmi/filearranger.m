%% 整理文件夹，统一命名
%% 目录筛选
num=0;
names=dir;
for i=1:length(names)
    if(names(i).isdir)
        if(strcmp(names(i).name,'.')||strcmp(names(i).name,'..'))
        else
            num=num+1;
            selected{num}=[names(i).name];
        end
    end
end

%% 读取RAW DATA
for d1=1:num
    cd(selected{d1});%打开第一层文件夹
    names2=dir;
    num2=0;
    for i=1:length(names2)
        if(names2(i).isdir)
            if(strcmp(names2(i).name,'.')||strcmp(names2(i).name,'..'))
            else
                num2=num2+1;
                selected2{num2}=[names2(i).name];
            end
        end
    end
    for d2=1:num2;
        cd(selected2{d2});
        matfileraw=[];
        if(isempty(dir(['*laser002*.mat'])))
            matfileraw=dir(['*laser+003*.mat']);
            bhvname='pain';
        else
            matfileraw=dir(['*laser002*.mat']);
            bhvname='ctrl';
        end
        
        matfilepcmi=dir(['*_laser_*.mat']);
        if(isempty(matfilepcmi))
            cd('..');
        else
%         loc=strfind(matfilepcmi.name,'_laser_');
        if(isempty(strfind(matfilepcmi.name,'post')))
            bhvname2='pre';
        else
            bhvname2='post';
        end
        
        date=matfileraw.name(5:8);
        ratnumber=numfinder(matfileraw.name,'rat');
        
        raw=load(matfileraw.name);      
        pcmi=load(matfilepcmi.name);
        
        cd('..');
        save(['Rat' num2str(ratnumber) '_laser_' bhvname '_' date],'-struct','raw');
        save(['Rat' num2str(ratnumber) '_laser_' bhvname '_' date '_pcmi_' bhvname2],'-struct','pcmi')
        end
    end
    cd('..')
end