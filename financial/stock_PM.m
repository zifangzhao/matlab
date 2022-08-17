%generation of probability matrix of STOCK
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

DTA=15;
L=100;
PM=zeros(DTA,L,L);
for idx=1:DTA
    for day=1:length(price)-idx
%         SO_idx=round((0.1+price(day))*5*L);  %range should a value from [-0.1 0.1],idx distributed on [1 L]
        SO_idx=round(amount(day)*L);
        SI_idx=round((0.1+price(day+idx))*5*L);
        SO_idx(SO_idx<1)=1;
        SO_idx(SO_idx>L)=L;
        SI_idx(SI_idx<1)=1;
        SI_idx(SI_idx>L)=L;
        PM(idx,SO_idx,SI_idx)=PM(idx,SO_idx,SI_idx)+1;
    end
    subplot(ceil(DTA^0.5),round(DTA^0.5),idx);
    imagesc(squeeze(PM(idx,:,:)));
    axis xy;
end

