%stock predict plot
function [predict_price_ratio predict]=stock_predict_v2(x,data_ori,fft_day,DTP,selected_para,name,column,plot_on,maxs,mins,profit,paras,st_h,bias)
%2013-6-28 增加修正分红的支持
%2013-7-2  增加输出预测数据，用于验证性能等
if nargin<14
    bias=zeros(size(data_ori));
end
if nargin<8
    plot_on=1;
end
data=data_ori;
data_restore=data_ori;
predict=zeros(DTP,size(data,1));
init_size=size(data);
levels=size(st_h,2);
for day=1:DTP+1;
    for sbp=1:size(data,1)
        p=x{1};
        if nargin>10 %使用profit模式
                p1=p(1:end-paras*levels,:);%p的构成 【第一参数|第一参数 第一参数|第二参数| 第二参数|第一参数| 第二参数|第二参数 第一参数|筹码 第二参数|筹码】
                p2=p(1+end-paras*levels:end,:);
%                 p=p1;
            predict(day,sbp)=sum([reshape([data(:,size(data,2)-fft_day:end-1) mean(data(:,size(data,2)-fft_day:end-1 ),2) ],[],1) ; profit(end,:)' ]...
                .*[p1(end/size(data_ori,1)*(sbp-1)+1:end/size(data_ori,1)*sbp) ; p2((sbp-1)*levels+1:sbp*levels)]);

        else
            predict(day,sbp)=sum(reshape([data(:,size(data,2)-fft_day:end-1) mean(data(:,size(data,2)-fft_day:end-1),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp));

        end
%         idx=fft_day:size(data,2)-1;
%         predict(day,sbp)=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp)),idx);
    end
    if day-1>0
        data(:,end+1)=predict(day,:)';
        if nargin>10
            [profit st_h]=stock_profit_estim(data(1,:),data(2,:),levels,profit,st_h);   %重新计算当前的收益持仓情况
        end
    end
end
predict=predict.*repmat(maxs-mins,[size(predict,1) 1])+repmat(mins,[size(predict,1) 1])+repmat(bias(:,end)',size(predict,1),1);
idx2=init_size(2):size(data,2);
data_restore=data_restore.*repmat(maxs'-mins',[1 size(data_ori,2)])+repmat(mins',[1 size(data_ori,2)])+bias;
for sbp=1:size(data,1)
    hold off
    idx=fft_day:size(data_ori,2)-1;
    post=zeros(size(data_ori,2),1);
    if nargin>10
        post(1+fft_day:end)=arrayfun(@(x) sum([reshape([data_ori(:,x-fft_day+1:x) mean(data_ori(:,x-fft_day+1:x),2)],[],1) ; profit(x,:)']...
            .*[p1(end/size(data_ori,1)*(sbp-1)+1:end/size(data_ori,1)*sbp) ; p2((sbp-1)*levels+1:sbp*levels)]),idx)...
            *(maxs(sbp)-mins(sbp))+mins(sbp);
    else
        post(1+fft_day:end)=(arrayfun(@(x) sum(reshape([data_ori(:,x-fft_day+1:x) mean(data_ori(:,x-fft_day+1:x),2)],[],1).*p(end/size(data_ori,1)*(sbp-1)+1:end/size(data_ori,1)*sbp)),idx))*(maxs(sbp)-mins(sbp))+mins(sbp);
    end
    post=post+bias(sbp,:)';
    if plot_on
        subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),sbp)
        plot(data_restore(sbp,:),'linewidth',2);
        hold on;
        plot(post,'r','linewidth',2);
        plot(idx2,predict(:,sbp),'g','linewidth',2)
%         y_lim=ylim;
%         ylim([0 y_lim(2)]);
        legend('实际','模拟','预测','location','West');
        hold off;
%         title([name column{sbp} ]);
    end
    ga_end(sbp)=post(end);
end
% data=data_ori;
predict_price_ratio=(predict(:,1)-ga_end(1))/ga_end(1);


if plot_on
    subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),1)
    title([name column{sbp} '最高 ' num2str(max(predict_price_ratio)) '平均 ' num2str(mean(predict_price_ratio))]);
end
        
