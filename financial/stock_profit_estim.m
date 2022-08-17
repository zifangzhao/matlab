% function for estimating the stock shareholder profit
function [profit st_h_all]=stock_profit_estim(price,amount,levels,profit_init,st_h_init)
%ע����������ݵ�һ���Ǽ۸񣬵ڶ�������
%5�������ݵ�Ԥ��Ч������
%����ÿһ��ʱ�̵ĳɽ��۸���ǵ�ǰƽ���۸�
%���ڱ�׼����ԭ�����������Ļ��ֶ���1
%�����Ľ��Ӧ��Ϊ��ǰ�ֲ�״̬�Ե�ǰ�۸�ı�׼������
%Ϊ�˱�֤����ṹ��ͳһ�ԣ��ֵ������ֲ�������һ������ΧΪ��-200% 200%��
price=mapminmax(price,0,1);
profit=zeros(length(price),levels); %��Ӧ�������µĳֲ����
if nargin>3
    profit(1:size(profit_init,1),:)=profit_init;
    start_idx=size(profit_init,1)+1;
    st_h=st_h_init(end,:)';
    st_h_all=ones(length(price),levels);
    st_h_all(1:end-1,:)=st_h_init;
    st_h_all(end,:)=st_h_all(end-1,:);
else
    start_idx=1;
    st_h=ones(levels,1); %�ֲ����
    st_h=st_h./sum(st_h);     %����ʼ�ֲ��趨��ƽ���ֲ�������ʷ��ߵ���ʷ���
    st_h_all=ones(length(price),levels);
end
% profit=profit./sum(profit);  %����ʼ�����趨��ƽ���ֲ�
% levels=levels-1;
%���������������Ҫ�ͼ۸��ں���ͬʱ����
prob_curve=0.3*length(st_h)+(1:length(st_h));
prob_curve=(prob_curve./sum(prob_curve))';
P_idx=ones(2,1);
for day=start_idx:length(price)  %����ÿһ����������������
    ratio=amount(day)/sum(prob_curve.*st_h);    %���ٵĵ�λ��
    st_h=st_h-st_h.*prob_curve*ratio;               %�µĲ����
    idx=1+floor((length(st_h)-1)*price(day));   %��ʱ��ļ۸��Ӧ�Ĳ�index
    st_h(idx)=st_h(idx)+amount(day);                 %�Ƚ��ü۸�Ĳ����Ӵ��¼��ĳɽ���
    for p=1:levels     %���㲻ͬ����Ĳּ��ٵ�������Χ��[-100% 100%]
        P_idx(1)=round((price(day)+(p-1-0.5*levels)/(0.5*levels))*levels);    %�껯�۸�x�ֵķּ���+��ǰ���������  P_idx��Ӧ������Ӧ�����Ӧ��ʵ�ʼ۸������ 
        %                                                  -0.5levels 0.5 levels ��Ҫ�������Χ��չ��[-1 1]
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
    profit(day,:)=profit(day,:)./sum(profit(day,:));%����profit,ʹ���ܺ�Ϊ1
%     profit_temp
%     profit_temp=st_h-price(day);
%     profit(day,:)=profit_temp;%hist(profit_temp,levels);
%     subplot(211);plot(st_h);subplot(212);plot(profit_temp,'r');
    st_h_all(day,:)=st_h;
end
% st_h_all(:,end)=std(st_h_all,0,2);
% profit(:,end)=std(profit,0,2);

end