function general_cluster_find_PCMI(searchkeyword,min_area,max_ecc,min_I,min_percent,plot_on)
%created by zifang zhao@ 2012-6-20 �������ļ�����Ѱ���ض�������������������ȡ

%% ���ݹؼ��ʲ���matfile
matfile=dir(['*' searchkeyword '*.mat']); %��������mat-file
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);

for file_idx=1:length(matfile)
    %% load MAT-files
    pcmi=load(matfile(file_idx).name,'-struct');
    
    %% �ֲ�ͬ��Ϊ����SL����
    
    
    %����������ȡ
    dataname=fieldnames(pcmi.data);
    eval(['trials=length(pcmi.data.' dataname{1} ';']);
    locs=cell(trials,1);
    stds=cell(trials,1);
    for trial=1:trials
        I_merge=cellfun(@cell_merge,pcmi.data.Ixys{trial},pcmi.data.Iyxs{trial}','UniformOutput',0);  %��Ixys��Iyxs�ϳ�һ�������
        locs{trial}=cell(size(I_merge));
        stds{trial}=cell(size(I_merge));
        [locs{trial} stds{trial}]=cellfun(@(x) cluster_find(x,min_area,max_ecc,min_I,min_percent,plot_on),I_merge,'UniformOutput',0);
    end
    
    
    pcmi.data=[];
    pcmi.data.locs=locs;
    pcmi.data.stds=stds;
   
    
    %�洢����
    fname=[matfile(file_idx).name(1:end-4) '_clus'];
    save(fname,'pcmi');
    clear('pcmi')
    
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end



function M=cell_merge(A,B)
M=[A,B];
end