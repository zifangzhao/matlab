%stock fix date
function stock=stock_fix_date(stock,date_template)
%stock.date is in datenum format
N=size(stock.data,2);
len=length(date_template);
data_fix=zeros(len,N);
idx=ismember(date_template,stock.date);
data_fix(idx,:)=stock.data;
void_idx=find(~idx);
valid_idx=find(idx);

if ismember(1,void_idx)
    data_fix(1,:)=stock.data(1,:);
    void_idx(1)=[];
end

for idx=1:length(void_idx)
   
    data_fix(void_idx(idx),:)=data_fix(void_idx(idx)-1,:);
end
stock.date=date_template;
stock.data=data_fix;
