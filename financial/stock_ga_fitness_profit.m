%stock ga fitness profit included
function [scores post_all]=stock_ga_fitness_profit(x,data,profit,fft_day,selected_para,day_pre)
%2013-7-5 增加day_pre
scores=zeros(size(x,1),1);   %scores for each population
% para_num=(length(x{j})-fft_day)/day;
% data_day=size(data_day,2);
levels=size(profit,2);
post_all=zeros(length(selected_para),size(data,2)-day_pre-fft_day+1);
for j=1:size(x,1)
    p_all=x{j};   %读入参数
    p=p_all(1:end-size(data,1)*size(profit,2),:);%p的构成 【第一参数|第一参数 第一参数|第二参数| 第二参数|第一参数| 第二参数|第二参数 第一参数|筹码 第二参数|筹码】
    p2=p_all(1+end-size(data,1)*size(profit,2):end,:);
    f=0;
    idx=fft_day:size(data,2)-day_pre;
%     post=arrayfun(@(x) sum(reshape([abs(fft(data(:,x-fft_day+1:x))) mean(data(:,x-fft_day+1:x),2)],[],1).*p),idx);
    for jj=selected_para  
        post=arrayfun(@(x) sum([reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2) ],[],1) ; profit(x,:)']...
            .*[p(end/size(data,1)*(jj-1)+1:end/size(data,1)*jj) ; p2((jj-1)*levels+1:jj*levels)]),idx);
        f=f+sum(abs(post-data(jj,idx+day_pre)));
        post_all(jj,:,j)=post;
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
    scores(j)=f;
end