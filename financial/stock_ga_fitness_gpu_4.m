%stock ga fitness
function scores=stock_ga_fitness_gpu(x,data,fft_day,selected_para,k,k2)

paras=size(data,1);
days=size(data,2);
popu=size(x,1);

k.ThreadBlockSize=[length(fft_day:days-1) paras 1];
k.GridSize=[paras,popu];

p=[x{:}];
f_m=zeros(paras,paras,length(fft_day:days-1),popu);
f_m=feval(k,f_m,data,p,int32(fft_day),int32(paras),int32(days),int32(size(p,1)));
% f_m=gather(f_m);
idx=fft_day:days-1;
% post=zeros(paras,length(idx));

k2.ThreadBlockSize=[length(fft_day:days-1) 1 1];
k2.GridSize=[1,popu];

f=zeros(length(idx),popu);
f=feval(k2,f,data(:,idx+1),f_m,paras,length(idx));
f=gather(f);
% f_sum=sum(f,1);
scores=sum(f(selected_para),1);
% for j=1:popu
%     post(:,:)=(sum(f_m(:,:,:,j),1)); %针对每个p值
%     f=1;
%     
%     for jj=selected_para  
% %         post2(jj,:)=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1)...
% %             .*p(end/(paras)*(jj-1)+1:end/(paras)*jj)),idx);
%         f=f*sum((abs(post(jj,:)-data(jj,idx+1))+1));
%     end
%     scores(j)=sum(f);
% end