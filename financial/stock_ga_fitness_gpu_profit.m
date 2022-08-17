%stock ga fitness
function scores=stock_ga_fitness_gpu_profit(x,data,profit,fft_day,selected_para,day_pre,k,k2,k3)

paras=size(data,1);
days=size(data,2); %总天数为data_analysis的长度
popu=size(x,1);
levels=size(profit,2);

len=days-fft_day-day_pre+1;
k.ThreadBlockSize=[len paras 1];
k.GridSize=[paras,popu];
% day_pre=0; %利用提前一天的数据计算
p_all=[x{:}];
p=p_all(1:end-paras*levels,:);%p的构成 【第一参数|第一参数 第一参数|第二参数| 第二参数|第一参数| 第二参数|第二参数 第一参数|筹码 第二参数|筹码】
% figure(2);imagesc(p_all)
f_m=zeros(paras,paras,len,popu);
f_m=feval(k,f_m,data(:,1:end-day_pre),p,int32(fft_day),int32(paras),int32(len+fft_day),int32(size(p,1))); %求未加入st_h的情况下预测值
% f_m=gather(f_m);

% %% 验证第一步
% f_val1=gather(f_m);
% post_stp1=squeeze(sum(f_val1,1));
% post_val1=zeros(length(selected_para),size(data,2)-day_pre-fft_day+1);
% for j=1:size(x,1)
%     p=x{j};   %读入参数
%     p=p(1:end-paras*levels,:);
%     f=1;
%     idx=fft_day:size(data,2)-day_pre;
% %     post=arrayfun(@(x) sum(reshape([abs(fft(data(:,x-fft_day+1:x))) mean(data(:,x-fft_day+1:x),2)],[],1).*p),idx);
%     for jj=selected_para  
%         post=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1)...
%             .*p(end/size(data,1)*(jj-1)+1:end/size(data,1)*jj)),idx);
%         post_val1(jj,:,j)=post;
%     end
% end

%% 开始第二步-增加st_h
p2=p_all(end-paras*size(profit,2)+1:end,:);

k3.ThreadBlockSize=[len 1 1];
k3.GridSize=[paras,popu];
f_m2=parallel.gpu.GPUArray.zeros(paras+1,paras,len,popu);
f_m2(1:paras,:,:,:)=f_m;
% f_m=zeros(1,paras,length(fft_day:days-1),popu);
idx=fft_day:days-day_pre;
f_m2=feval(k3,f_m2,profit(idx,:),p2,int32(levels),int32(paras),int32(len),int32(size(p,1)));%增加st_h以后的预测值

% %% 验证第二步
% f_val2=gather(f_m);
% post_stp12=squeeze(sum(f_val2(1:2,:,:,:),1));
% post_stp2=squeeze(sum(f_val2,1));
% post_all=zeros(length(selected_para),size(data,2)-day_pre-fft_day+1);
% for j=1:size(x,1)
%     p_all=x{j};   %读入参数
%     p=p_all(1:end-size(data,1)*size(profit,2),:);%p的构成 【第一参数|第一参数 第一参数|第二参数| 第二参数|第一参数| 第二参数|第二参数 第一参数|筹码 第二参数|筹码】
%     p2=p_all(1+end-size(data,1)*size(profit,2):end,:);
%     f=0;
%     idx=fft_day:size(data,2)-day_pre;
% %     post=arrayfun(@(x) sum(reshape([abs(fft(data(:,x-fft_day+1:x))) mean(data(:,x-fft_day+1:x),2)],[],1).*p),idx);
%     for jj=selected_para  
%         post=arrayfun(@(x) sum([reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2) ],[],1) ; profit(x,:)']...
%             .*[p(end/size(data,1)*(jj-1)+1:end/size(data,1)*jj) ; p2((jj-1)*levels+1:jj*levels)]),idx);
%         f=f+sum(abs(post-data(jj,idx+day_pre)));
%         post_val2(jj,:,j)=post;
%     end
% end

%% 开始第三步
k2.ThreadBlockSize=[len 1 1];
k2.GridSize=[1,popu];

f=zeros(len,popu);
f=feval(k2,f,data(:,idx+day_pre),f_m2,paras+1,paras,length(idx));
f=gather(f);
% scores2=stock_ga_fitness_cpu_profit_vec(x,data,profit,fft_day,selected_para,day_pre,k,k2,k3)
scores=sum(f,1);

% %% 验证第三步
% f2=squeeze(sum(gather(f_m2),1));
% for j=1:size(x,1)
%     f3=0;
%     for jj=selected_para
%         f3=f3+sum(abs(f2(jj,idx-fft_day+1,j)-data(jj,idx+day_pre)));
%     end
%     scores_val(j)=f3;
% end
    

end
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