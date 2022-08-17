function stock=stock_date_fix(stock)
for idx=1:length(stock)
    stock{idx}.date=cellfun(@date_fix,stock{idx}.date);
end

function date_new=date_fix(date)
date_new=str2double([date(7:end) date(1:2) date(4:5)]);

