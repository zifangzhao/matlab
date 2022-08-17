clear;
dataA=randn([1 10000]);
dataB=randn([1 10000]);
% dataA=sin(1:1000);
% dataB=cos(1:1000);
% w2=200;
% w1=5;
% embedding=3;
% vec_num=w2-w1+1;
stps=0:1:100;
delays=0:1:50;
delay_0=25;
stps=stps+delay_0;
delays=delays-delay_0;
% sampling_delay=2;
% p_ref=0.05;
% distA=zeros(length(stps)*vec_num,1);
data_in=[dataA;dataB]; 
delay_len=length(delays);
stp_len=length(stps);
% g=gpuDevice;
% trim_len=ceil(max(delays)+max(stps)+2*w2);
for w1=5%5:10:20
    for w2=200%100:50:500
        for sampling_delay=2%:5:20
            for embedding=2%3:3:15
                for p_ref=0.5%:0.1:0.1
                    
                    SL_m=SL_mex(data_in,w1,w2,embedding,sampling_delay,p_ref,stps,delays); %%%THIS METHOD MUST HAVE A DELAY STARTING FROM 0!
                    SL_m2=reshape(SL_m,size(data_in,1),size(data_in,1),length(stps),length(delays));
                    SL_3=cell(2);
                    for A=1:size(data_in,1)
                        for B=1:size(data_in,1)
                            SL_3{A,B}=squeeze(SL_m2(A,B,:,:))';
                        end
                    end
                    SL_c=SL_single_twosided(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays);
%                     [w1 w2 sampling_delay embedding p_ref]
                    subplot(311)
                    imagesc(SL_c)
                    subplot(312)
                    imagesc(SL_3{1,2})
                    subplot(313)
                    imagesc(SL_c-SL_3{1,2});
                    colorbar
% %                     clear('SL_3','SL_m2','SL_m')
%                     g.reset;
%                     pause
                end
            end
        end
    end
end
% quit
% distant_m=reshape(SL_m{5},100,388,2);
% cdist=reshape(SL_m{6},100,2);
% distA2=squeeze(distant_m(1:100,:,1));
% for idx=1:100
%     pattern2(idx,:)=distA2(idx,:)<=cdist(idx,1);
% end


k=parallel.gpu.CUDAKernel('cal_dist_2.ptx','cal_dist_2.cu');%创建核函数
k.ThreadBlockSize=[1024 1 1];
k.GridSize=[64 1];
% SL_g=SL_single_twosided_gpu_k_v5(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k);



% k=parallel.gpu.CUDAKernel('cal_dist_3.ptx','cal_dist_3.cu');%创建核函数
% SL_g2=SL_single_twosided_gpu_k_v5(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k);

% k.ThreadBlockSize=[1024 1 1];
% k.GridSize=[64 1];
% SL_g=SL_single_twosided_gpu_k_v5(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k);
% distA=feval(k,distA,reshape(dataA,1,[]),stps,w1:w2,int32(embedding));
% distA=gather(distA);
% k=parallel.gpu.CUDAKernel('cal_dist.ptx','cal_dist.cu');%创建核函数
% k.ThreadBlockSize=[vec_num 1 1];
% k.GridSize=[1 stp_len];
% k.SharedMemorySize=8*vec_num*embedding;
% % distA=feval(k,distA,reshape(dataA,1,[]),stps,w1:w2,int32(embedding));
% % distA=gather(distA);
% k=parallel.gpu.CUDAKernel('cal_dist.ptx','cal_dist.cu');%创建核函数
% k.ThreadBlockSize=[vec_num 1 1];
% k.GridSize=[1 stp_len];
% k.SharedMemorySize=8*vec_num*embedding;
% SL_g2=SL_single_gpu_k(dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,k);
% k.delete;

% g=gpuDevice(1)
% reset(g)