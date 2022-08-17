%stock predict plot
function stock=stock_predict_v3(stock,selected_para,DTP,plot_on)
%��Ϊͨ�ýṹ
%2013-6-28 ���������ֺ��֧��
%2013-7-2  �������Ԥ�����ݣ�������֤���ܵ�
x=stock.x;
data_ori=stock.data_analysis;
fft_day=stock.fft_day;
day_pre=stock.day_pre;
name=stock.name;
column=stock.column;
maxs=stock.maxs;
mins=stock.mins;
offset=stock.offset;
st_h=stock.st_h(end-size(data_ori,2)-offset+1:end-offset,:);
profit=stock.profit;
paras=length(column);

bias=stock.bias_full;

if isempty(find(strcmp(fieldnames(stock),'bias'), 1))
    bias=zeros(size(data_ori));
end

data=data_ori;
data_restore=data_ori;

predict=zeros(DTP+1,size(data,1));
init_size=size(data);
levels=size(st_h,2);
idx=fft_day:size(data_ori,2)-day_pre;  %


for day=1:DTP+1; %��Ԥ��Ķ�һ�����Է���ԭʼ����
    for sbp=1:size(data,1)
        p=x{1};

        p1=p(1:end-paras*levels,:);%p�Ĺ��� ����һ����|��һ���� ��һ����|�ڶ�����| �ڶ�����|��һ����| �ڶ�����|�ڶ����� ��һ����|���� �ڶ�����|���롿
        p2=p(1+end-paras*levels:end,:);
        %                 p=p1;
        t_m=day-day_pre-1;  %�������һ�ε�ʱ��ѡ�񣬵���û�е�Ԥ�������ʱ������ʹ��Ԫ����,����һ������
%         if t_m>day_pre
%             t_m=day_pre;
%         end
        predict(day,sbp)=sum([reshape([data(:,init_size(2)-fft_day+t_m+1:init_size(2)+t_m) ...
            mean(data(:,init_size(2)-fft_day+t_m+1:init_size(2)+t_m),2) ],[],1) ; profit(init_size(2)+t_m,:)' ]...
            .*[p1(end/size(data_ori,1)*(sbp-1)+1:end/size(data_ori,1)*sbp) ; p2((sbp-1)*levels+1:sbp*levels)]);

        %         idx=fft_day:size(data,2)-1;
%         predict(day,sbp)=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp)),idx);
    end
    if day>day_pre
        data(:,init_size(2)+t_m+1)=predict(day,:)';
        [profit st_h]=stock_profit_estim(data(1,:),data(2,:),levels,profit,st_h);   %���¼��㵱ǰ������ֲ����

    end
end
predict=predict.*repmat(maxs-mins,[size(predict,1) 1])+repmat(mins,[size(predict,1) 1])+repmat(bias(end,:),size(predict,1),1);
idx2=init_size(2):size(data,2);
data_restore=data_restore.*repmat(maxs'-mins',[1 size(data_ori,2)])+repmat(mins',[1 size(data_ori,2)])+bias';
for sbp=1:size(data,1)
    hold off
    
    post=zeros(size(data_ori,2),1);
    post(idx+day_pre)=arrayfun(@(x) sum([reshape([data_ori(:,x-fft_day+1:x) mean(data_ori(:,x-fft_day+1:x),2)],[],1) ; profit(x-day_pre,:)']...
        .*[p1(end/size(data_ori,1)*(sbp-1)+1:end/size(data_ori,1)*sbp) ; p2((sbp-1)*levels+1:sbp*levels)]),idx)...
        *(maxs(sbp)-mins(sbp))+mins(sbp);
    idx_post=idx+day_pre;
    post=post+bias(:,sbp);
    if plot_on
        subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),sbp)
        plot(data_restore(sbp,:),'linewidth',2);
        hold on;
        plot(idx_post,post(idx_post),'r','linewidth',2);
        plot(idx2,predict(:,sbp),'g','linewidth',2)
%         y_lim=ylim;
%         ylim([0 y_lim(2)]);
        legend('ʵ��','ģ��','Ԥ��','location','West');
        hold off;
%         title([name column{sbp} ]);
    end
    ga_end(sbp)=post(end);
end
% data=data_ori;
predict_price_ratio=(predict(:,1)-ga_end(1))/ga_end(1);


if plot_on
    subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),1)
    title([name column{sbp} '��� ' num2str(max(predict_price_ratio)) 'ƽ�� ' num2str(mean(predict_price_ratio))]);
end
stock.predict=predict_price_ratio;
stock.predict_raw=predict;

