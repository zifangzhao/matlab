%stock GA algorithm parallel script
function [stock predict_avg column selected_para] = stock_script_ga_all_par(para_sel,days,fft_day,day_predict,gen,popu,tol)
next_idx=0;
current_idx=next_idx;
file_idx=0;
batch_size=10;
multiWaitbar('Close all')
multiWaitbar('总进度:',0,'color',[0.3 0.6 0.4]);


multiWaitbar('正在分配任务:',0,'color',[0.6 0.4 0.2]);
multiWaitbar('检查状态:',0,'color',[0.2 0.4 0.4]);

temp_file=dir('stock_temp_*.mat');
temp_num=zeros(length(temp_file),1);
for idx=1:length(temp_file)
    temp_num_1=strfind(temp_file(idx).name,'_');
    temp_num_2=strfind(temp_file(idx).name,'.');
    temp_num(idx)=str2double(temp_file(idx).name(temp_num_1(end)+1:temp_num_2-1));
end
try
    [~,idx_max]=max(temp_num);
    load(temp_file(idx_max).name);
catch err
    [~,idx_max]=max(temp_num);
    if idx_max>1
        load(temp_file(idx_max-1).name);
    end
end
while next_idx~=Inf
    current_idx=next_idx;
    [stock next_idx max_idx]=stock_read_v3(next_idx+1,batch_size,days);
    sch=parcluster();
    for idx=1:length(sch.Jobs)
        sch.Jobs(1).delete;
    end
    
    for stock_idx=1:length(stock);
        clear('data_analysis')
        
        data_current=stock{stock_idx}.data;
        % data_current=data_current./repmat(sum(data_current,1),size(data_current,1),[]);
        % data_analysis=data_current;
        for d_idx=1:length(para_sel)
            switch para_sel(d_idx)
                case 1
                    data_analysis(:,d_idx)=data_current(:,4)./sum(data_current(:,4));column{d_idx}=' 标化收盘价';%d_idx=d_idx+1;  %normailized end price
                case 2
                    data_analysis(:,d_idx)=(data_current(:,4)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化增长率';%d_idx=d_idx+1; %increase rate
                case 3
                    data_analysis(:,d_idx)=(data_current(:,2)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最高';%d_idx=d_idx+1; %max rate
                case 4
                    data_analysis(:,d_idx)=(data_current(:,3)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最低';%d_idx=d_idx+1; %min rate
                case 5
                    data_analysis(:,d_idx)=data_current(:,5)./sum(data_current(:,5));column{d_idx}=' 标化量';%d_idx=d_idx+1;   %normalized volume
                case 6
                    data_analysis(:,d_idx)=data_current(:,6)./sum(data_current(:,6));column{d_idx}=' 标化额';%d_idx=d_idx+1;   %normalized amount
            end
        end
        %     days=200;  %Days to analysis
        %     data_analysis_ori=data_analysis(end-days:end,:);
        data_analysis=data_analysis(end-days+1:end,:);
        % data_analysis=data_analysis';
        data_analysis=mapminmax(data_analysis',0,1);
        
        selected_para=1:size(data_analysis,1);
        N=ceil(fft_day+1)*size(data_analysis,1)*size(data_analysis,1);
        create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
        %     plot_fcn=@(options,state,flag) stock_ga_plot(options,state,flag,data_analysis,fft_day,stock{stock_idx}.name,selected_para,column);
        % plot_fcn=@stock_ga_plot_simple;
        %setting up the GA
        options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
        options=gaoptimset(options,'CreationFcn',create_fcn,...
            'CrossoverFcn',@stock_ga_crossover,...
            'MutationFcn',@stock_ga_mutation,...       'PlotFcn',plot_fcn,...
            'PlotInterval',50,...
            'Generations',gen,'PopulationSize',popu,...
            'StallGenLimit',200,'Vectorized','on',...
            'UseParallel','always',...
            'FitnessLimit',-Inf,...
            'TolCon',tol,...
            'TolFun',tol);
        stock{stock_idx}.data_analysis=data_analysis;
    end
    
    predict_avg=zeros(length(stock),1);
    
    
    multiWaitbar('正在分配任务:','Reset','color',[0.6 0.4 0.2]);
    multiWaitbar('检查状态:','Reset','color',[0.2 0.4 0.4]);
    
    jh=[];
    for stock_idx=1:length(stock);
        %         try
        jh=[jh batch(sch,@stock_ga_gpu_start,1,{stock{stock_idx}.data_analysis,fft_day,selected_para,N,options})];
        %         catch err
        %             break;
        %         end
        multiWaitbar('正在分配任务:',(stock_idx)/length(stock),'color',[0.6 0.4 0.2]);
    end
    job_ok=zeros(length(stock));
    job_map=1:length(stock);
%     while length(stock)-sum(job_ok)
        for idx=1:length(stock)
            wait(jh(idx));
            if strcmp({sch.Jobs(job_map(idx)).State},'finished')
                job_ok(idx)=1;
%             else
%                 job_map(idx)=length(sch.Jobs)+1;
%                 batch(sch,@stock_ga_gpu_start,1,{stock{idx}.data_analysis,fft_day,selected_para,N,options});
            end
            multiWaitbar('检查状态:',(idx)/length(stock),'color',[0.2 0.4 0.4]);
        end
%     end
    
    
    for stock_idx=1:length(stock);
        if job_ok(stock_idx)==1
            r=fetchOutputs(sch.Jobs(job_map(stock_idx)));
            x=r{1};
        else
            x=stock_ga_gpu_start(stock{idx}.data_analysis,fft_day,selected_para,N,options);
        end
        stock{stock_idx}.x=x;
        %         figure(2);
        stock{stock_idx}.predict=stock_predict(stock{stock_idx}.x,stock{stock_idx}.data_analysis,fft_day,day_predict,selected_para,stock{stock_idx}.name,column,0);
        predict_avg(stock_idx)=median(stock{stock_idx}.predict);
    end
    for idx=1:length(sch.Jobs)
        sch.Jobs(1).delete;
    end
%     calculated=calculated+cal;
    multiWaitbar('总进度:',next_idx/max_idx,'color',[0.3 0.6 0.4]);
    %     stock{stock_idx}.predict=stock_predict(x,data_analysis,fft_day,day_predict,selected_para,stock{stock_idx}.name,column);
    file_idx=file_idx+1;
    save(['stock_temp_' num2str(file_idx) '.mat'],'stock','predict_avg','column','selected_para','current_idx','next_idx','file_idx')
    
end
stock=cell(max_idx,1);
predict_avg=zeros(max_idx,1);
current_idx=1;
for idx=1:file_idx
    file=load(['stock_temp_' num2str(idx) '.mat']);
    file_len=length(file.stock);
    stock(current_idx:current_idx+file_len-1)=file.stock;
    predict_avg(current_idx:current_idx+file_len-1)=file.predict_avg;
    current_idx=current_idx+file_len+1;
    system(['del "' 'stock_temp_' num2str(idx) '.mat"']);
end
for idx=length(stock):-1:1
    if isempty(stock{idx})
        stock(idx)=[];
        predict_avg(idx)=[];
    end
end
multiWaitbar('Close all')

% k.delete;
