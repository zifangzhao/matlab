%function stock_bias_fix
function stock=stock_bias_fix(stock)
%除权除息价=(股权登记日的收盘价－每股所分红利现金额+配股价×每股配股数)÷(1+每股送红股数+每股配股数)
%配股除权价=（除权登记日收盘价+配股价*每股配股比例）/（1+每股配股比例）
%share ratio= 6xN double [每n1股派n2元 送n3股 转增n4股 配n5股 配股价n6]
for idx=1:length(stock)
    stock{idx}=stock_process(stock{idx});
end

function s=stock_process(s) %处理单个股票
data=s.data;
sr_all=s.shareratio;
bias=zeros(size(data,1),1);
for idx=1:size(s.shareratio,2)
%     day_idx=find(cellfun(@(x) ~isempty(strfind(x,s.sharedate{idx})),s.date));
    sr=sr_all(:,idx);
    day_idx=find(s.date==s.sharedate(idx),1,'first');
    price=data(day_idx,4); %除权前一天的收盘价
    price_new=(price-sr(2)/sr(1)+sr(6)*sr(5)/sr(1))/(1+sr(3)/sr(1)+sr(5)/sr(1));
    bias(day_idx:end)=bias(day_idx:end)-(price-price_new);
end
s.bias=bias;