%generation of multiple conditional %generation of probability matrix (MCPM)of STOCK
s=stock_read_v3(1,10,1000);
s=stock_f10_add(s);
s=stock_date_fix(s);
s=stock_bias_fix(s);
s_idx=8;
price=s{s_idx}.data(:,4)-s{s_idx}.bias;
price_var=diff(price)./price(1:end-1);
price=price_var;

amount=s{s_idx}.data(:,6);
amount=mapminmax(amount',0,1)';
amount(1)=[];
% price=mapminmax(price',0,1)';
% plot(price-s{1}.bias)

DTA=2;
L=6;
PM=zeros([ones(1+DTA,1).*L]');
idx_mul=ones(DTA+1,1);
for idx=1:DTA+1
    idx_mul(idx)=L^(idx-1);
end
for day=1:length(price)-DTA
    idx_vec=round((0.1+price(day:day+DTA))*5*L);
    idx_vec(idx_vec<1)=1;
    idx_vec(idx_vec>L)=L;
    
    idx=1+sum((idx_vec-1).*idx_mul);
    PM(idx)=PM(idx)+1;
    
    
end
% %Smooth to PM
% PM_fix=zeros(size(PM));
% zero_idx=

