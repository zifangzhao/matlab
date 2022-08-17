%stock ga fitness
function scores=stock_ga_fitness_gpu(x,data,fft_day,selected_para,k)
scores=zeros(size(x,1),1);
k.ThreadBlockSize=[length(fft_day:size(data,2)-1) size(data,1) 1];
k.GridSize=[size(data,1),size(x,1)];

p=[x{:}];
f_m=zeros(size(data,1),size(data,1),length(fft_day:size(data,2)-1),size(x,1));
f_m=feval(k,f_m,data,p,int32(fft_day),int32(size(data,1)),int32(size(data,2)),int32(size(p,1)));
f_m=gather(f_m);
idx=fft_day:size(data,2)-1;
post=zeros(size(data,1),length(idx));

for j=1:size(x,1)
    post(:,:)=(sum(f_m(:,:,:,j),1));
    f=1;
    
    for jj=selected_para  
%         post2(jj,:)=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1)...
%             .*p(end/(size(data,1))*(jj-1)+1:end/(size(data,1))*jj)),idx);
        f=f*sum((abs(post(jj,:)-data(jj,idx+1))+1));
    end
    scores(j)=sum(f);
end