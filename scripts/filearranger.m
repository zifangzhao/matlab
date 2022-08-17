%% 整理文件夹，统一命名
%2012-4-11 by Zifang Zhao 修正"行为_phase"命名问题

%% 输入参数
startpoints=[4 100;5 92;6 89;7 119;8 76;11 65;12 62;13 75; 14 62;15 78;16 62;17 69];
phasename={'phaseI','phaseMid','phaseII'};



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
    matfile_formalin=dir('*formalin*.mat');
    date=matfile_formalin.name(1:8);
    ratnumber=numfinder(matfile_formalin.name,'rat');
    raw_filename=['Rat' num2str(ratnumber) '_formalin_' date '_raw'];
    raw=load(matfile_formalin.name);
    save(raw_filename,'-struct','raw');
    delete([matfile_formalin.name]);
    
    matfile_base=dir('*baseline*.mat');
    date=matfile_base.name(1:8);
    ratnumber=numfinder(matfile_base.name,'rat');
    base_filename=['Rat' num2str(ratnumber) '_baseline_' date '_raw'];
    base=load(matfile_base.name);
    save(base_filename,'-struct','base');
    delete([matfile_base.name]);
    startpoint=startpoints(startpoints(:,1)==ratnumber,2);
    
    phase=[startpoint startpoint+300; startpoint+300 startpoint+1200;startpoint+1200 startpoint+3600];
    xlsfile_formalin=dir('*newfor*.xls');
    xls=importdata(xlsfile_formalin.name);
    xls_field=fieldnames(xls);
    new_data=[];
    new_field=[];
    idx=0;
    for fld=1:length(xls_field)
        field=xls_field{fld};
        eval(['xls_data=xls.' field ';']);
        for phs=1:length(phasename);
            tmp=findinrange(xls_data,phase(phs,:));
            if(isempty(tmp))
            else
                idx=idx+1;
                new_data{idx}=tmp;
                new_field{idx}=[field phasename{phs}];
                xlswrite(raw_filename,new_data{idx},new_field{idx});
            end
        end
    end
    
    phase_base=[startpoint startpoint+600];
    xlswrite(base_filename,phase_base,'base')
    sheet123cleaner([raw_filename '.xls'],pwd);
    sheet123cleaner([base_filename '.xls'],pwd);
    cd('..')
end 