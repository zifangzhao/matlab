%stock GA algorithm test
function [stock predict_avg column selected_para] = stock_script_ga_single_profit(stock,day_predict,day_pre,gen,popu,tol,offset,levels)

selected_para=1:size(data_analysis,1);
N=(levels+(fft_day+1)*size(data_analysis,1))*size(data_analysis,1);
create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
plot_fcn=@(options,state,flag) stock_ga_plot_v2(options,state,flag,data_analysis,profit,fft_day,day_pre,stock{stock_idx}.name,selected_para,column,length(selected_para),levels);
%setting up the GA
options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
options=gaoptimset(options,'CreationFcn',create_fcn,...
    'CrossoverFcn',@stock_ga_crossover,...
    'MutationFcn',@stock_ga_mutation,...                 'PlotFcn',plot_fcn,...            'PlotInterval',100,...
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
hold on;
stock{stock_idx}=stock_predict_v3(stock{stock_idx},selected_para,day_predict,0);
predict_avg(stock_idx,:)=max(stock{stock_idx}.predict);




if ~gpu_not_working
    k.delete;
end

