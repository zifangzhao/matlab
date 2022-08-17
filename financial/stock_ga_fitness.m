%stock ga fitness
function scores=stock_ga_fitness(x,data,fft_day,selected_para)
scores=zeros(size(x,1),1);   %scores for each population
% para_num=(length(x{j})-fft_day)/day;
% data_day=size(data_day,2);
for j=1:size(x,1)
    p=x{j};   %∂¡»Î≤Œ ˝
    f=1;
    idx=fft_day:size(data,2)-1;
%     post=arrayfun(@(x) sum(reshape([abs(fft(data(:,x-fft_day+1:x))) mean(data(:,x-fft_day+1:x),2)],[],1).*p),idx);
    for jj=selected_para  
        post=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1)...
            .*p(end/size(data,1)*(jj-1)+1:end/size(data,1)*jj)),idx);
        f=f*sum((abs(post-data(jj,idx+1))+1));
    end
%     f=abs(mapminmax(post',0,1)'-data(1,idx));
%     for i=1+fft_day:size(data,2)
%         Y=data(:,i-fft_day+1:i);
% %         Y=abs(fft(data(:,i-fft_day+1:i)));
% %         Y=Y(1:ceil(end/2));
%         data_pre=reshape([Y mean(data(:,i-fft_day+1:i),2)],[],1); %fft_day/2*p
%         post=sum(data_pre.*p);
%         f=f+abs(post-data(1,i));
%     end
    scores(j)=sum(f);
end