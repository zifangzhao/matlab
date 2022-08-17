%stock GA algorithm test
clc
clear;
if matlabpool('size')==0
    matlabpool
end
stock=stock_read_v2;
choice=cellfun(@(x) x.name,stock,'UniformOutput',0);
[sel,v]=listdlg('PromptString','选择要分析的股票',...
    'SelectionMode','single',...
    'ListString',choice);
stock_idx=sel;
data_current=stock{stock_idx}.data;
% data_current=data_current./repmat(sum(data_current,1),size(data_current,1),[]);
% data_analysis=data_current;
d_idx=1;
data_analysis(:,d_idx)=data_current(:,4)./sum(data_current(:,4));column{d_idx}=' 标化收盘价';d_idx=d_idx+1;  %normailized end price
% data_analysis(:,d_idx)=(data_current(:,4)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化增长率';d_idx=d_idx+1; %increase rate
% data_analysis(:,d_idx)=(data_current(:,2)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最高';d_idx=d_idx+1; %max rate
% data_analysis(:,d_idx)=(data_current(:,3)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最低';d_idx=d_idx+1; %min rate
% data_analysis(:,d_idx)=data_current(:,5)./sum(data_current(:,5));column{d_idx}=' 标化量';d_idx=d_idx+1;   %normalized volume
data_analysis(:,d_idx)=data_current(:,6)./sum(data_current(:,6));column{d_idx}=' 标化额';d_idx=d_idx+1;   %normalized amount
days=200;  %Days to analysis
data_analysis_ori=data_analysis(end-days:end,:);
data_analysis=data_analysis(end-days:end,:);
% data_analysis=data_analysis';
data_analysis=mapminmax(data_analysis',0,1);
fft_day=ceil(0.3*days);
selected_para=1:size(data_analysis,1);
N=ceil(fft_day+1)*size(data_analysis,1)*size(data_analysis,1);
create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
plot_fcn=@(options,state,flag) stock_ga_plot(options,state,flag,data_analysis,fft_day,stock{stock_idx}.name,selected_para,column);
% plot_fcn=@stock_ga_plot_simple;
%setting up the GA
options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
options=gaoptimset(options,'CreationFcn',create_fcn,...
    'CrossoverFcn',@stock_ga_crossover,...
    'MutationFcn',@stock_ga_mutation,... 
    'PlotFcn',plot_fcn,...
    'PlotInterval',50,...
    'Generations',3000,'PopulationSize',200,...
    'StallGenLimit',200,'Vectorized','on',...
    'UseParallel','always',...
    'FitnessLimit',-Inf,...
    'TolCon',1e-10,...
    'TolFun',1e-10);

%GA start
k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
fitnessfcn=@(x) stock_ga_fitness_gpu(x,data_analysis,fft_day,selected_para,k);

[x,fval,reason,output]=ga(fitnessfcn,N,options);

%Data to predict
hold on;
day_predict=30;
predict=stock_predict(x,data_analysis,fft_day,day_predict,selected_para,stock{stock_idx}.name,column);

