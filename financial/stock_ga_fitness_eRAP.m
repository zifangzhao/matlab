%eRAP model fitness function
function scores=stock_ga_fitness_eRAP(x,data,fft_day,selected_para)
% 输入必须是【标化价 变化率 额】
scores=zeros(size(x,1),1);
% para_num=(length(x{j})-fft_day)/day;
% data_day=size(data_day,2);
for j=1:size(x,1) %子代选择
    p=x{j};   %读入参数
%     f=1;
    idx=fft_day:size(data,2)-1;
    related_para1=[1 3];
    P=arrayfun(@(x) sum(reshape([data(related_para1,x-fft_day+1:x) mean(data(related_para1,x-fft_day+1:x),2)],[],1)...
        .*p(1:(fft_day+1)*2)),idx);
    R= [diff([data(1,fft_day-1) P])] ./data(1,idx);
    M=sign(data(2,:)).*(exp(abs(mapminmax(data(2,:),-1,1)))-1).*data(3,:);
    related_para3=[1];
    A=arrayfun(@(x) sum(reshape([data(related_para3,x-fft_day+1:x) mean(data(related_para3,x-fft_day+1:x),2) M(x-fft_day+1:x) mean(M(x-fft_day+1:x),2)],[],1)...
        .*p((fft_day+1)*2+1:end)),idx);
    f=sum(abs(P-data(1,idx+1)))+sum(abs(R-data(2,idx+1)))+sum(abs(A-data(3,idx+1)));
    % for jj=selected_para   %计算各个参数集对目标参数的影响
%           
%         post=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1)...
%             .*p(end/size(data,1)*(jj-1)+1:end/size(data,1)*jj)),idx);
%         f=f*sum((abs(post-data(jj,idx+1))+1));
%     end
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