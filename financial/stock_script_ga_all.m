%stock GA algorithm test
function [stock predict_avg column selected_para] = stock_script_ga_all(para_sel,days,fft_day,day_predict,gen,popu,tol,offset)

% if matlabpool('size')==0
%     matlabpool
% end
next_idx=0;
current_idx=next_idx;
file_idx=0;
batch_size=100;

multiWaitbar('Close all')
multiWaitbar('总进度:',0,'color',[0.3 0.6 0.4]);
multiWaitbar('正在分配任务:',0,'color',[0.6 0.4 0.2]);
% warning off;
temp_file=dir('stock_temp_*.mat');
temp_num=zeros(length(temp_file),1);

if ~isempty(temp_file);
    choice = questdlg('发现以前的数据文件，是否继续进行计算?', ...
        '发现临时文件', ...
        '是','否','是');
    if strcmp(choice,'是')
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
    else
        for idx=length(temp_file):-1:1
            system(['del ' temp_file(idx).name]);
        end
    end
end
while next_idx~=Inf
    current_idx=next_idx;
    [stock next_idx max_idx]=stock_read_v3(next_idx+1,batch_size,days+offset+1);
    stock=stock_f10_add(stock);
    % stock=stock_read_v3(1,[],days+offset+1);
    predict_avg=zeros(length(stock),day_predict+1);
    multiWaitbar('正在分配任务:',0,'color',[0.6 0.4 0.2]);
    
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
                case 7
                    vari=(2*(((data_current(:,4)-data_current(:,1))>0)-0.5));
                    
                    data_analysis(:,d_idx)=vari.^3.*data_current(:,6)./sum(data_current(:,6));column{d_idx}=' 加权额'; %乘上增长率正负的额
            end
        end
        %     days=200;  %Days to analysis
        %     data_analysis_ori=data_analysis(end-days:end,:);
        data_analysis=data_analysis(end-days-offset:end-offset,:);
        % data_analysis=data_analysis';
        stock{stock_idx}.mins=min(data_analysis,[],1);  %存储最小值和最大值
        stock{stock_idx}.maxs=max(data_analysis,[],1);
        data_analysis=mapminmax(data_analysis',0,1);
        %     fft_day=ceil(0.3*days);
        selected_para=1:2;
        N=ceil(fft_day+1)*size(data_analysis,1)*size(data_analysis,1);
        create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
        %     plot_fcn=@(options,state,flag) stock_ga_plot(options,state,flag,data_analysis,fft_day,stock{stock_idx}.name,selected_para,column);
        % plot_fcn=@stock_ga_plot_simple;
        %setting up the GA
        options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
        options=gaoptimset(options,'CreationFcn',create_fcn,...
            'CrossoverFcn',@stock_ga_crossover,...
            'MutationFcn',@stock_ga_mutation,...            'PlotFcn',plot_fcn,...
            'PlotInterval',50,...
            'Generations',gen,'PopulationSize',popu,...
            'StallGenLimit',200,'Vectorized','on',...
            'UseParallel','always',...
            'FitnessLimit',-Inf,...
            'TolCon',tol,...
            'TolFun',tol);
        stock{stock_idx}.data_analysis=data_analysis;
        %GA start
        gpu_not_working=0;
        try
            k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
            k2=parallel.gpu.CUDAKernel('stock_accelerate_step2.ptx','stock_accelerate_step2.cu');
            fitnessfcn=@(x) stock_ga_fitness_gpu(x,data_analysis,fft_day,selected_para,k,k2);
        catch
            gpu_not_working=1;
            if matlabpool('size')==0
                matlabpool
            end
            fitnessfcn=@(x) stock_ga_fitness(x,data_analysis,fft_day,selected_para);
        end
        [x,fval,reason,output]=ga(fitnessfcn,N,options);
        stock{stock_idx}.x=x;
        %Data to predict
        hold on;
        %     day_predict=15;
        stock{stock_idx}.predict=stock_predict_v2(x,data_analysis,fft_day,day_predict,selected_para,stock{stock_idx}.name,column,0,stock{stock_idx}.maxs,stock{stock_idx}.mins);
        predict_avg(stock_idx,:)=max(stock{stock_idx}.predict);
%         multiWaitbar('总进度:',stock_idx/length(stock),'color',[0.3 0.6 0.4]);
        multiWaitbar('正在分配任务:',stock_idx/length(stock),'color',[0.6 0.4 0.2]);
        
        
    end
    file_idx=file_idx+1;
    save(['stock_temp_' num2str(file_idx) '.mat'],'stock','predict_avg','column','selected_para','current_idx','next_idx','file_idx','max_idx')
    
    multiWaitbar('总进度:',next_idx/max_idx,'color',[0.3 0.6 0.4]);
    
end


stock=cell(max_idx,1);
predict_avg=zeros(max_idx,day_predict+1);
current_idx=1;
for idx=1:file_idx
    file=load(['stock_temp_' num2str(idx) '.mat']);
    file_len=length(file.stock);
    stock(current_idx:current_idx+file_len-1)=file.stock;
    predict_avg(current_idx:current_idx+file_len-1,:)=file.predict_avg;
    current_idx=current_idx+file_len+1;
    system(['del "' 'stock_temp_' num2str(idx) '.mat"']);
end
for idx=length(stock):-1:1
    if isempty(stock{idx})
        stock(idx)=[];
        predict_avg(idx,:)=[];
    end
end

if ~gpu_not_working
    k.delete;
end
multiWaitbar('Close all');
