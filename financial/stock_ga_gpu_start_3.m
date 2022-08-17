%ga GPU starter
function x=stock_ga_gpu_start(data_analysis,fft_day_temp,selected_para_temp,N,options)
k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
k2=parallel.gpu.CUDAKernel('stock_accelerate_step2.ptx','stock_accelerate_step2.cu');

fitnessfcn=@(x) stock_ga_fitness_gpu(x,data_analysis,fft_day_temp,selected_para_temp,k,k2);
[x,fval,reason,output]=ga(fitnessfcn,N,options);
k.delete;
