%stock GA algorithm test
function [stock predict_avg column selected_para] = stock_script_ga_all_eRAP(para_sel,days,fft_day,day_predict,gen,popu,tol,offset)

% if matlabpool('size')==0
%     matlabpool
% end
stock=stock_read_v3(1,[],days+offset);
predict_avg=zeros(length(stock),day_predict);
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
                
                data_analysis(:,d_idx)=vari.^3.*data_current(:,6);column{d_idx}=' 加权额'; %乘上增长率正负的额
        end
    end
%     days=200;  %Days to analysis
%     data_analysis_ori=data_analysis(end-days:end,:);
data_analysis=data_analysis(end-days-offset:end-offset,:);
% data_analysis_ori=data_analysis';
data_analysis=data_analysis';
stock{stock_idx}.mins=min(data_analysis,[],1);  %存储最小值和最大值
stock{stock_idx}.maxs=max(data_analysis,[],1);
% data_analysis=mapminmax(data_analysis',0,1);
% data_analysis(2,:)=data_analysis_ori(2,:)./max(data_analysis_ori(2,:));
%     fft_day=ceil(0.3*days);
    selected_para=1:size(data_analysis,1);
%     N=ceil(fft_day+1)*size(data_analysis,1)*size(data_analysis,1);
    N=4*ceil(fft_day+1);
    create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
    plot_fcn=@(options,state,flag) stock_ga_plot_eRAP(options,state,flag,data_analysis,fft_day,stock{stock_idx}.name,selected_para,column);
    % plot_fcn=@stock_ga_plot_simple;
    %setting up the GA
    options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
    options=gaoptimset(options,'CreationFcn',create_fcn,...
        'CrossoverFcn',@stock_ga_crossover,...
        'MutationFcn',@stock_ga_mutation,...      
        'PlotFcn',plot_fcn,...
        'PlotInterval',5,...
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
        fitnessfcn=@(x) stock_ga_fitness_gpu_eRAP(x,data_analysis,fft_day,selected_para,k,k2);
    catch
        gpu_not_working=1;
        if matlabpool('size')==0
            matlabpool
        end
        fitnessfcn=@(x) stock_ga_fitness_eRAP(x,data_analysis,fft_day,selected_para);
    end
    [x,fval,reason,output]=ga(fitnessfcn,N,options);
    stock{stock_idx}.x=x;
    %Data to predict
    hold on;
%     day_predict=15;
    stock{stock_idx}.predict=stock_predict_v2(x,data_analysis,fft_day,day_predict,selected_para,stock{stock_idx}.name,column,0,stock{stock_idx}.maxs,stock{stock_idx}.mins);
    predict_avg(stock_idx,:)=max(stock{stock_idx}.predict);
    multiWaitbar('总进度:',stock_idx/length(stock),'color',[0.3 0.6 0.4]);
end
if ~gpu_not_working
    k.delete;
end
multiWaitbar('Close all');
