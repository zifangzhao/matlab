% function for estimating the stock shareholder profit
function [profit st_h_all]=stock_profit_estim(price,amount,levels,profit_init,st_h_init)
%注意输入的数据第一行是价格，第二行是量
%5分钟数据的预测效果更好
%假设每一个时刻的成交价格就是当前平均价格
%由于标准化的原因，这两个量的积分都是1
%给出的结果应当为当前持仓状态对当前价格的标准化收益
%为了保证计算结构的统一性，仓的量级分布和天数一样，范围为【-200% 200%】
price=mapminmax(price,0,1);
profit=zeros(length(price),levels); %相应收益率下的持仓情况
if nargin>3
    profit(1:size(profit_init,1),:)=profit_init;
    start_idx=size(profit_init,1)+1;
    st_h=st_h_init(end,:)';
    st_h_all=ones(length(price),levels);
    st_h_all(1:end-1,:)=st_h_init;
    st_h_all(end,:)=st_h_all(end-1,:);
else
    start_idx=1;
    st_h=ones(levels,1); %持仓情况
    st_h=st_h./sum(st_h);     %给初始持仓设定成平均分布，从历史最高到历史最低
    st_h_all=ones(length(price),levels);
end
% profit=profit./sum(profit);  %给初始收益设定成平均分布
% levels=levels-1;
%计算出的收益率需要和价格在后期同时修正
prob_curve=0.3*length(st_h)+(1:length(st_h));
prob_curve=(prob_curve./sum(prob_curve))';
P_idx=ones(2,1);
for day=start_idx:length(price)  %遍历每一天的情况来计算收益
    ratio=amount(day)/sum(prob_curve.*st_h);    %减少的单位数
    st_h=st_h-st_h.*prob_curve*ratio;               %新的仓情况
    idx=1+floor((length(st_h)-1)*price(day));   %这时间的价格对应的仓index
    st_h(idx)=st_h(idx)+amount(day);                 %先将该价格的仓增加此事件的成交量
    for p=1:levels     %计算不同收益的仓减少的量，范围是[-100% 100%]
        P_idx(1)=round((price(day)+(p-1-0.5*levels)/(0.5*levels))*levels);    %标化价格x仓的分级数+当前计算的收益  P_idx对应的是相应收益对应的实际价格的坐标 
        %                                                  -0.5levels 0.5 levels 需要将这个范围扩展到[-1 1]
        P_idx(2)=round((price(day)+(p-0.5*levels)/(0.5*levels))*levels);
        if p==1
            P_idx(1)=1;
        end
        if p==levels
            P_idx(end)=levels;
        end
        P_idx(P_idx<1)=1;
        P_idx(P_idx>levels)=levels;
        if P_idx(1)==P_idx(2)
            profit(day,p)=0;
        else
            profit(day,p)=sum(st_h(P_idx(1):P_idx(2)));
        end
    end
    profit(day,:)=profit(day,:)./sum(profit(day,:));%修正profit,使其总和为1
%     profit_temp
%     profit_temp=st_h-price(day);
%     profit(day,:)=profit_temp;%hist(profit_temp,levels);
%     subplot(211);plot(st_h);subplot(212);plot(profit_temp,'r');
    st_h_all(day,:)=st_h;
end
% st_h_all(:,end)=std(st_h_all,0,2);
% profit(:,end)=std(profit,0,2);

end