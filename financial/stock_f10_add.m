%stock F10 data add to stock
function stock=stock_f10_add(stock)
% cwd=pwd;
s_path1='D:\stock\vipdoc\shf10\';
s_path2='D:\stock\vipdoc\szf10\';
s_path='e:\stock\f10\';
% cd('e:\stock\f10');
for idx=1:length(stock)
%     f_o=fileread('000004.txt');
    try
    f_o=fileread([s_path1 stock{idx}.name(1:6) '.txt']);
    catch
        try
            f_o=fileread([s_path2 stock{idx}.name(1:6) '.txt']);
        catch
            f_o=fileread([s_path stock{idx}.name(1:6) '.txt']);
        end
    end
%     f=f(1:3000);
    table_idx=strfind(f_o,'股本结构>'):strfind(f_o,'股本结构>')+1000;
    f=f_o(table_idx);
    [~,~,~,~,amt]=regexpi(f,'总股本.*?(\d+.?\d*)│','match');
    if isnan(str2double(amt{1}))
        this will wrong
    end
    stock{idx}.amountall=str2double(amt{1})*1e8;
    table_idx=strfind(f_o,'历年分配>'):strfind(f_o,'分析评论>');
    f_share=f_o(table_idx);
    share_idx1_all=regexpi(f_share,',每\d+股.*?\d{4}-\d{2}-\d{2}');
    
    stock{idx}.shareratio=zeros(6,length(share_idx1_all));
    stock{idx}.sharedate=zeros(length(share_idx1_all),1);
    for idx2=1:length(share_idx1_all)
        share_idx1=share_idx1_all(idx2);
        if idx2~=length(share_idx1_all)
            f_seg=f_share(share_idx1_all(idx2):share_idx1_all(idx2+1));
            
        else
            f_seg=f_share(share_idx1_all(idx2):end);
        end
        %每x股派x元送x股转增x股
        share_idx2=regexpi(f_seg,'派\d');
        share_idx3=regexpi(f_seg,'送\d');
        share_idx4=regexpi(f_seg,'转增\d');
        share_idx5=regexpi(f_seg,'配\d');
        share_idx6=regexpi(f_seg,'配股价\d');
        date_idx=strfind(f_seg,'除息日');
        if isempty(date_idx)
            date_idx=strfind(f_seg,'除权日');
        end
        if isempty(date_idx)
            date_idx=1;
        end
        date_temp=regexpi(f_seg(date_idx:end),'\d{4}.\d+.\d+','match');
        date_temp=date_temp(1);
        year=regexpi(date_temp,'\d{4}','match');
        date_temp=regexprep(date_temp,'[年月]','-');
        month=regexpi(date_temp,'-\d+-','match');
        day=regexpi(date_temp,'-\d+','match');
%         day=day(end);
%         stock{idx}.sharedate{idx2}=[month{1}{1}(2:end-1) '/' day{1}{end}(2:end) '/' year{1}{1}];
        stock{idx}.sharedate(idx2)=str2double([ year{1}{1} month{1}{1}(2:end-1)  day{1}{end}(2:end)]);
        if ~isempty(share_idx1)
            share_temp1=regexpi(f_seg,'\d+\.*\d*','match');
            stock{idx}.shareratio(1,idx2)=str2double(share_temp1(1));
        else
            stock{idx}.shareratio(1,idx2)=0;
        end
        if ~isempty(share_idx2)
            share_temp2=regexpi(f_seg(share_idx2:end),'\d+\.*\d*','match');
            stock{idx}.shareratio(2,idx2)=str2double(share_temp2(1));
        else
            stock{idx}.shareratio(2,idx2)=0;
        end
        if ~isempty(share_idx3)
            share_temp3=regexpi(f_seg(share_idx3:end),'\d+\.*\d*','match');
            stock{idx}.shareratio(3,idx2)=str2double(share_temp3(1));
        else
            stock{idx}.shareratio(3,idx2)=0;
        end
        if ~isempty(share_idx4)
            share_temp4=regexpi(f_seg(share_idx4:end),'\d+\.*\d*','match');
            stock{idx}.shareratio(4,idx2)=str2double(share_temp4(1));
        else
            stock{idx}.shareratio(4,idx2)=0;
        end
        if ~isempty(share_idx5)
            share_temp5=regexpi(f_seg(share_idx5:end),'\d+\.*\d*','match');
            stock{idx}.shareratio(5,idx2)=str2double(share_temp5(1));
        else
            stock{idx}.shareratio(5,idx2)=0;
        end
        if ~isempty(share_idx6)
            share_temp6=regexpi(f_seg(share_idx6:end),'\d+\.*\d*','match');
            stock{idx}.shareratio(6,idx2)=str2double(share_temp6(1));
        else
            stock{idx}.shareratio(6,idx2)=0;
        end
        
    end
end
% cd(cwd);