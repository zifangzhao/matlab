%% general  PCMI for spike
%%2012-4-5 by zifang zhao 增加跳过已计算文件的功能
%%2012-4-4 by zifang zhao 修正excel文件名,单页表格问题
%searchkeyword,bin,order,tau,delta
%     bin   : the time window for discritizing spike trains,default is 0.001s;
%     order : data points within a motif, default is 2;
%     tau   : the number of data points between the adjacent two points of the motif, default is 1;
%     delta : delay time in conditional mutual information, not less than order, larger than the maximum delay, default is order:100;
function general_pcmi_spike(searchkeyword,bin,order,tau,delta)
% searchkeyword='raw';
matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
% h1=waitbar(0,'Over all progress of one bhv');
% h2=waitbar(0,'Processing neurons...');
% h3=waitbar(0,'Overall progress:');
% pos_w1=get(h1,'position');
% pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];set(h2,'position',pos_w2,'doublebuffer','on')
% pos_w3=[pos_w1(1) pos_w1(2)-pos_w1(4) pos_w1(3) pos_w1(4)];set(h3,'position',pos_w3,'doublebuffer','on')
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);
for file_idx=1:length(matfile)
    
    %% load MAT-files
    % [filename pathname]=uigetfile('*.mat','Load raw data file');
    % rawdata=load([pathname filename]); %读取原始文件
    rawdata=load(matfile(file_idx).name);
    msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
    %% load 行为xls (including starts,ends)
    %     [filename pathname]=uigetfile('*.xls','Select behavior definition');
    %     filename=[filename(1:end-7) 'bhv.xls'];
    %     filename=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'bhv.xls'];
    filename=[matfile(file_idx).name(1:end-4) '.xls'];
    [~,field_names,~]=xlsfinfo(filename);
    if length(field_names)>1
        behavior = importdata(filename);
    else
        eval(['behavior.' field_names{1} '=importdata(filename);']);
    end
    
    %% channel picking筛选出有效通道
    attrname='unit2';
    chans=channelpick(fieldnames(rawdata),'elec',attrname);
    %% data_reorganize
    for i = 1:length(chans)
        eval(['rawdata_valid{i} = rawdata.elec' num2str(chans(i)) '_' attrname ';']);
    end
    
    multiWaitbar('Sub classifications:',0,'color',[0.5 1 0.5]);
    %% 分不同行为进行PCMI计算
    bhv_name=fieldnames(behavior);
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'pcmi_' fieldname '.mat'];
        if isempty(dir(fname))
            eval(['bhv_time=behavior.' fieldname ';']);
            if(isempty(bhv_time))
                starts=[];
                ends=[];
            else
                starts=bhv_time(:,1);
                ends=bhv_time(:,2);
            end
            
            %进行pcmi计算
            [DP_indexs,DP_index_mean,Ixy_max,Iyx_max,Ixys,Iyxs]=pcmi(rawdata_valid,starts,ends,chans,10,bin,order,tau,delta);
            
            %存储数据
            
            
            save(fname,'DP_indexs','DP_index_mean','Ixy_max','Iyx_max','Ixys','Iyxs');
            clear('DP_indexs','DP_index_mean','Ixy_max','Iyx_max','Ixys','Iyxs')
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end
