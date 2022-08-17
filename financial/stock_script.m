%script for stock analysis
stock=stock_read_v2;
stock_idx=1;
day_num=365;
price_o=stock{stock_idx}.data(:,1);amount_o=stock{stock_idx}.data(:,6);
amount=amount_o(end-day_num:end);price=price_o(end-day_num:end);
stock_nn2;

