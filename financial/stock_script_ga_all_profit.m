%stock GA algorithm test
function [stock predict_avg column selected_para] = stock_script_ga_all_profit(days,fft_day,day_predict,day_pre,gen,popu,tol,offset,levels)

% if matlabpool('size')==0
%     matlabpool
% end
% day_pre=5; %利用提前几天的数据进行预测  
next_idx=0;
current_idx=next_idx;
file_idx=0;
batch_size=100;
para_sel=[1 5];
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
    [stock next_idx max_idx]=stock_read_v3(next_idx+1,batch_size,days+offset+1);%读取文件，每次读取一个batch
    stock=stock_f10_add(stock);%加入f10的资料，总股本，bias
    stock=stock_date_fix(stock);%将f10和tag的日期修为double
    stock=stock_bias_fix(stock);  %修正分红
    % stock=stock_read_v3(1,[],days+offset+1);
    predict_avg=zeros(length(stock),day_predict+1); %初始化预测值矩阵，长度为【股票数，预测天数+最后一天】
    multiWaitbar('正在分配任务:',0,'color',[0.6 0.4 0.2]);
    column=cell(length(para_sel),1);   %选取的参数名初始化
    for stock_idx=1:length(stock);
        data_current=stock{stock_idx}.data;
        data_analysis=zeros(size(data_current,1),length(para_sel)); %需要对每一只股票初始化
       %% 根据bias修正价格
        bias=stock{stock_idx}.bias;
        data_current(:,4)=data_current(:,4)-bias;
        
        %% 建立需要分析的数据集
        % data_current=data_current./repmat(sum(data_current,1),size(data_current,1),[]);
        % data_analysis=data_current;
        for d_idx=1:length(para_sel)
            switch para_sel(d_idx)
                case 1
                    data_analysis(:,d_idx)=data_current(:,4);column{d_idx}=' 标化收盘价';%d_idx=d_idx+1;  %normailized end price
                    %                     data_analysis(:,d_idx)=data_current(:,4)./sum(data_current(:,4));column{d_idx}=' 标化收盘价';%d_idx=d_idx+1;  %normailized end price
                case 2
                    data_analysis(:,d_idx)=(data_current(:,4)-data_current(:,1));column{d_idx}=' 标化增长率';%d_idx=d_idx+1; %increase rate
                    %                     data_analysis(:,d_idx)=(data_current(:,4)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化增长率';%d_idx=d_idx+1; %increase rate
                case 3
                    data_analysis(:,d_idx)=(data_current(:,2)-data_current(:,1));column{d_idx}=' 标化最高';%d_idx=d_idx+1; %max rate
                    %                     data_analysis(:,d_idx)=(data_current(:,2)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最高';%d_idx=d_idx+1; %max rate
                case 4
                    data_analysis(:,d_idx)=(data_current(:,3)-data_current(:,1));column{d_idx}=' 标化最低';%d_idx=d_idx+1; %min rate
                    %                     data_analysis(:,d_idx)=(data_current(:,3)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最低';%d_idx=d_idx+1; %min rate
                case 5
                    data_analysis(:,d_idx)=data_current(:,5);column{d_idx}=' 标化量';%d_idx=d_idx+1;   %normalized volume
                    %                     data_analysis(:,d_idx)=data_current(:,5)./sum(data_current(:,5));column{d_idx}=' 标化量';%d_idx=d_idx+1;   %normalized volume
                case 6
                    data_analysis(:,d_idx)=data_current(:,6);column{d_idx}=' 标化额';%d_idx=d_idx+1;   %normalized amount
                    %                     data_analysis(:,d_idx)=data_current(:,6)./sum(data_current(:,6));column{d_idx}=' 标化额';%d_idx=d_idx+1;   %normalized amount
                case 7
                    data_analysis(:,d_idx)=2*(((data_current(:,4)-data_current(:,1))>0)-0.5).*data_current(:,6);column{d_idx}=' 加权额'; %乘上增长率正负的额
                    %                     data_analysis(:,d_idx)=2*(((data_current(:,4)-data_current(:,1))>0)-0.5).*data_current(:,6)./sum(data_current(:,6));column{d_idx}=' 加权额'; %乘上增长率正负的额
            end
        end
        bias_full=zeros(size(data_analysis)); %建立区段修正矩阵
        bias_full(:,1)=bias;
        [profit st_h]=stock_profit_estim(mapminmax(data_current(:,4)',0,1)',data_current(:,5)./stock{stock_idx}.amountall,levels);   %分析仓情况
%         data_analysis=[data_analysis profit];
        %     days=200;  %Days to analysis
        %     data_analysis_ori=data_analysis(end-days:end,:);
        analysis_idx=size(data_analysis,1)-days-offset-day_pre+1:(size(data_analysis,1)-offset); %从最初的原始数据中提取的时间段，取出的数据长度为days+day_pre
        data_analysis=data_analysis(analysis_idx,:);
        bias_full=bias_full(analysis_idx,:);
        profit=profit(analysis_idx,:);
        stock{stock_idx}.offset=offset;
        
%         data_analysis=data_analysis';
        stock{stock_idx}.mins=min(data_analysis,[],1);  %存储最小值和最大值
        stock{stock_idx}.maxs=max(data_analysis,[],1);
        data_analysis=mapminmax(data_analysis',0,1);   %标化原始数据
        %     fft_day=ceil(0.3*days);
        selected_para=1:size(data_analysis,1);
        N=(levels+(fft_day+1)*size(data_analysis,1))*size(data_analysis,1); 
        create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
        plot_fcn=@(options,state,flag) stock_ga_plot_v2(options,state,flag,data_analysis,profit,fft_day,day_pre,stock{stock_idx}.name,selected_para,column,length(selected_para),levels);
%         plot_fcn=@stock_ga_plot_simple;
        %setting up the GA
        options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
        options=gaoptimset(options,'CreationFcn',create_fcn,...
            'CrossoverFcn',@stock_ga_crossover,...
            'MutationFcn',@stock_ga_mutation,...                 
            'PlotFcn',plot_fcn,...          
            'PlotInterval',100,...
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
%             this will make a halt;
            k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
            k2=parallel.gpu.CUDAKernel('stock_accelerate_step2.ptx','stock_accelerate_step2.cu');
            k3=parallel.gpu.CUDAKernel('stock_accelerate_profit.ptx','stock_accelerate_profit.cu');
            fitnessfcn=@(x) stock_ga_fitness_gpu_profit(x,data_analysis,profit,fft_day,selected_para,day_pre,k,k2,k3);
%             fitnessfcn=@(x) stock_ga_fitness_gpu_profit(x,data_analysis,st_h,fft_day,selected_para,k,k2,k3);
        catch
            gpu_not_working=1;
            if matlabpool('size')==0
                matlabpool
            end
            fitnessfcn=@(x) stock_ga_fitness_profit(x,data_analysis,profit,fft_day,selected_para,day_pre);
        end
        [x,fval,reason,output]=ga(fitnessfcn,N,options);
        stock{stock_idx}.x=x;
        stock{stock_idx}.profit=profit;
        stock{stock_idx}.st_h=st_h;
        stock{stock_idx}.bias_full=bias_full;
        stock{stock_idx}.day_pre=day_pre;
        stock{stock_idx}.column=column;
        stock{stock_idx}.fft_day=fft_day;
        %Data to predict
        hold on;
        %     day_predict=15;
%         [predict_ratio predict_raw]=stock_predict_v2(x,data_analysis,fft_day,day_predict,selected_para,...
%             stock{stock_idx}.name,column,0,stock{stock_idx}.maxs,stock{stock_idx}.mins,...
%             profit,length(selected_para),st_h(end-offset-size(data_analysis,2)+1:end-offset,:),bias_full');
%         stock{stock_idx}.predict=predict_ratio;
%         stock{stock_idx}.predict_raw=predict_raw;
        stock{stock_idx}=stock_predict_v3(stock{stock_idx},selected_para,day_predict,0);
%         pause();
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
