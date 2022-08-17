%stock predict plot
function predict_price=stock_predict(x,data_ori,fft_day,DTP,selected_para,name,column,plot_on)
if nargin<8
    plot_on=1;
end
data=data_ori;
predict=zeros(DTP,size(data,1));
init_size=size(data);

for day=1:DTP+1;
    for sbp=1:size(data,1)
        p=x{1};
        predict(day,sbp)=sum(reshape([data(:,size(data,2)-fft_day:end-1) mean(data(:,size(data,2)-fft_day:end-1),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp));
%         idx=fft_day:size(data,2)-1;
%         predict(day,sbp)=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp)),idx);
    end
    if day-1>0
        data(:,end+1)=predict(day,:)';
    end
end
idx2=init_size(2):size(data,2);
for sbp=1:size(data,1)
    if plot_on
        subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),sbp)
        plot(data_ori(sbp,:),'linewidth',2);
        hold on;
    end
    idx=fft_day:size(data_ori,2)-1;
    post=zeros(size(data_ori,2),1);
    post(1+fft_day:end)=arrayfun(@(x) sum(reshape([data_ori(:,x-fft_day+1:x) mean(data_ori(:,x-fft_day+1:x),2)],[],1).*p(end/size(data_ori,1)*(sbp-1)+1:end/size(data_ori,1)*sbp)),idx);
    if plot_on
        plot(post,'r','linewidth',2);
        plot(idx2,predict(:,sbp),'g','linewidth',2)
        legend('Êµ¼Ê','Ä£Äâ','Ô¤²â','location','EastOutside');
        hold off;
        title([name column{sbp}]);
    end
    ga_end(sbp)=post(end);
end
% data=data_ori;
predict_price=(predict(:,1)-ga_end(1))/ga_end(1);