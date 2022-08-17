%% general  PCMI for LFP
% revised by zifang zhao @ 2012-10-17 修正快速继续
%%2012-5-6 revised by Zifang Zhao added input:stps,improved xlsfile searching
%%2012-4-5  version by  zifang zhao 增加跳过计算过文件的功能  增加对短数据的剔除功能
%%2012-4-4  version by  zifang zhao 修正了读取excel文件名的问题，单页表格问题
%%2012-3-27 version by  zifang zhao added resampling
%searchkeyword,bin,order,tau,delta
%     order : data points within a motif, default is 2;
%     tau   : the number of data points between the adjacent two points of the motif, default is 1;
%     delta : delay time in conditional mutual information, not less than order, larger than the maximum delay, default is order:100;
function general_pcmi_LFP(searchkeyword,system_fs,res_fs,order,tau,delta,stps)
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

    msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
    %% load 行为xls (including starts,ends)
    %     [filename pathname]=uigetfile('*.xls','Select behavior definition');
    %     filename=[filename(1:end-7) 'bhv.xls'];
    %     filename=[matfile(file_idx).name(1:end-4-length(searchkeyword)) '.xls'];
    
    filename=[matfile(file_idx).name(1:end-7) '*.xls'];  %通过raw之前的字符查找，确保_raw在文件名最后
    xlsfile=dir(filename);
    filename=xlsfile(1).name;
    [~,field_names,~]=xlsfinfo(filename);
    if length(field_names)>1
        behavior = importdata(filename);
    else
        eval(['behavior.' field_names{1} '=importdata(filename);']);
    end


    
    multiWaitbar('Sub classifications:',0,'color',[0.5 1 0.5]);
    %% 分不同行为进行PCMI计算
    bhv_name=fieldnames(behavior);
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'pcmi_' fieldname '.mat'];
        if isempty(dir(fname))
            rawdata=load(matfile(file_idx).name);
            %% channel picking筛选出有效通道
            chans=channelpick(fieldnames(rawdata),'elec');
            %% data_reorganize
            for i = 1:length(chans)
                eval(['rawdata_valid{i} = resample(rawdata.elec' num2str(chans(i)) ',res_fs,system_fs);']);
            end
            eval(['bhv_time=behavior.' fieldname ';']);
            if(isempty(bhv_time))
                starts=[];
                ends=[];
            else
                starts_ori=bhv_time(:,1);
                ends_ori=bhv_time(:,2);
                idx=find(floor((ends_ori-starts_ori)*res_fs)>max(delta));
                if isempty(idx)
                    starts=[];
                    ends=[];
                else
                    starts=starts_ori(idx);
                    ends=ends_ori(idx);
                end
            end
            
            %进行pcmi计算
            [Delays,Ixys,Iyxs,DPs]=pcmi_LFP(rawdata_valid,res_fs,starts,ends,chans,order,tau,delta,stps);
%             Ixymax_Ixy=Ixys.Ixy;
%             Ixymax_Iyx=Ixys.Iyx;
%             Ixymax_delay=Ixys.delay;
%             Iyxmax_Ixy=Iyxs.Ixy;
%             Iyxmax_Iyx=Iyxs.Iyx;
%             Iyxmax_delay=Iyxs.delay;
            %存储数据
%             save(fname,'Ixymax_Ixy','Ixymax_Iyx','Ixymax_delay','Iyxmax_Ixy','Iyxmax_Iyx','Iyxmax_delay');
            save(fname,'Delays','Ixys','Iyxs','DPs');
%             clear('Ixys','Iyxs')
            
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end
