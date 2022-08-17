function [stock current_idx max_idx]=stock_read_v3(init_idx,batch_size,days)
%2013-6-28 更改日期存储为矩阵
% cd(uigetdir(pwd,'Please reselect container folder location'));

txtfile=dir('*.txt');
max_idx=length(txtfile);
if isempty(batch_size)
    batch_size=max_idx;
end
if init_idx+batch_size-1<length(txtfile)
    txtfile=txtfile(init_idx:init_idx+batch_size-1);
    current_idx=init_idx+batch_size-1;
else
    txtfile=txtfile(init_idx:end);
    current_idx=Inf;
end
im_data=arrayfun(@(x) importdata(x.name),txtfile,'UniformOutput',0);
loc1=cell2mat(cellfun(@(x) isstruct(x),im_data,'UniformOutput',0));
% loc2=cellfun(@(x) size(x.data,1)>0&&size(x.data,2)==6,im_data(loc1),'UniformOutput',0);
stock=cellfun(@(x) trim_file(x),im_data(loc1),'UniformOutput',0);
len=cellfun(@(x) length(x.data),stock);
stock(len<days)=[];
% stock=fix_file(stock,txtfile(loc1));

end
% fclose(fid);
function out_data=trim_file(im_data)
% im_data.textdata(1:4,:)=[];
out_data.data=[];
out_data.date={[]};
out_data.name=[];
if ~isempty(fieldnames(im_data))
    out_data.data=(im_data.data);
    rowstart=find(strcmp(im_data.textdata(:,1),'日期')|strcmp(im_data.textdata(:,1),'时间'))+1;
    out_data.date=im_data.textdata(rowstart(1):rowstart(1)+size(im_data.data,1)-1,1);
    out_data.name=im_data.textdata{1};
end
% out_data.data=normalize(im_data.data);


end

function out=normalize(in)
out=in./repmat(max(in),size(in,1),1);
end

function stock=fix_file(stock,txtfile)
date_temp=cell(length(stock),1);
for idx=1:length(stock)
    date_temp{idx}=stock{idx}.date';
end
date_u=unique([date_temp{cell2mat(arrayfun(@(x) ~isempty(x),date_temp,'UniformOutput',0))}])';
date_u=date_sort(date_u);
day_num=length(date_u);
%fill the blank days
for idx=1:length(stock)
    temp=nan(day_num,size(stock{idx}.data,2));
    
    day_exist=zeros(length(date_u),1);
    cnt=1;
    for idx_day=1:length(date_temp{idx})
        while 1
            if isequal(date_u(cnt),date_temp{idx}(idx_day))
                day_exist(idx_day)=cnt;
                cnt=cnt+1;
                break;
            end
            cnt=cnt+1;
        end
    end
    day_exist(day_exist==0)=[];
%     day_exist= cell2mat(cellfun(@(x) find(strcmp(date_u,x)),date_temp{idx},'UniformOutput',0));
    %     day_exist=sum(strcmp(date_sstemp(idx),date_u),2);
    temp(day_exist,:)=stock{idx}.data;
    nan_loc=find(isnan(temp(:,1)));
    if ~isempty(nan_loc)
        if nan_loc(1)==1
            temp(1,:)=zeros(1,size(temp,2));
            nan_loc(1)=[];
        end
        for idx2=1:length(nan_loc)
           temp(nan_loc(idx2),:)=temp(nan_loc(idx2)-1,:);
        end
    end
    stock{idx}.data=temp;
    stock{idx}.file=txtfile(idx).name;
    stock{idx}.date=date_u;
end
end
function date_new=date_sort(date)
date_new=date;
date_n=zeros(length(date),4);
date_n(:,4)=1:length(date);
for idx=1:length(date)
    date_n(idx,1)=str2double(date{idx}(1:2)); %mm
    date_n(idx,2)=str2double(date{idx}(4:5)); %dd
    date_n(idx,3)=str2double(date{idx}(7:end)); %yyyy
end
date_n=sortrows(date_n,[3,1,2]);
for idx=1:length(date)
    date_new{idx}=date{date_n(idx,4)};
end
end
% function out=data_merge(in)
%
% end