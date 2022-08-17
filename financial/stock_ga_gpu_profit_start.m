%ga GPU starter
function x_all=stock_ga_gpu_profit_start(stock,fft_day_temp,selected_para,N,day_pre,options)
k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
k2=parallel.gpu.CUDAKernel('stock_accelerate_step2.ptx','stock_accelerate_step2.cu');
k3=parallel.gpu.CUDAKernel('stock_accelerate_profit.ptx','stock_accelerate_profit.cu');

num=length(stock);
x_all=cell(num,1);

for idx=1:num
    fitnessfcn=@(x) stock_ga_fitness_gpu_profit(x,stock{idx}.data_analysis,stock{idx}.profit,fft_day_temp,selected_para,day_pre,k,k2,k3);
    [x_all(idx),~,~,~]=ga(fitnessfcn,N,options);
end
k.delete;
k2.delete;


