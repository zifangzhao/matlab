function unified=reformat_nonstruct_pcmi(data,res_fs,embedding,tau)
% created by zifang zhao @ 2012-6-21 将新旧格式的pcmi数据统一为新格式 ,将Ixys、Iyxs融合
fields=fieldnames(data);
if  ~isempty(cell2mat(strfind(fields,'data')))
    unified=data;
else
    if ~isempty(cell2mat(strfind(fields,'Ixys')))
        
        
        non_empty_trials=find(cell2mat(cellfun(@(x) ~isempty(x{1,2}),data.Ixys,'UniformOutput',0)));
        I_merge=cell(length(non_empty_trials),1);
        for trial=1:length(non_empty_trials)
            I_merge{trial}=cellfun(@cell_merge,data.Ixys{trial},data.Iyxs{trial}','UniformOutput',0);  %将Ixys、Iyxs合成一个大矩阵
        end
        
        
        unified.data.I=I_merge;
        
        
        stp_dly=size(data.Ixys{non_empty_trials(1)});
        
        unified.startpoint=(1:stp_dly(1))*1000/res_fs;
        unified.delay=(1:stp_dly(2))*1000/res_fs;
        unified.embedding=embedding;
        unified.tau=tau;
        unified.fs=res_fs;
    else
        unified=[];
    end
end
end
function M=cell_merge(A,B)
M=[A,B];
end