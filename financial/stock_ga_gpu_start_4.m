%ga GPU starter
function x_all=stock_ga_gpu_start(stock,fft_day_temp,selected_para,N,options)
k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
k2=parallel.gpu.CUDAKernel('stock_accelerate_step2.ptx','stock_accelerate_step2.cu');

num=length(stock);
x_all=cell(num,1);

for idx=1:num
    fitnessfcn=@(x) stock_ga_fitness_gpu(x,stock{idx}.data_analysis,fft_day_temp,selected_para,k,k2);
    [x_all(idx),~,~,~]=ga(fitnessfcn,N,options);
end
k.delete;
k2.delete;


