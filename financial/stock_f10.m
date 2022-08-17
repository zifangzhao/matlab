%stock F10 data read
function f10=stock_f10()
% cwd=pwd;
s_path='e:\stock\f10\';
files=dir([s_path '*.txt']);
f10=cell(length(files),1);
for idx=1:length(files)
    f10{idx}.name=files(idx).name;
    f_o=fileread([s_path stock{idx}.name(1:6) '.txt']);
%     f=f(1:3000);
    table_idx=strfind(f_o,'��˾�ſ�>'):strfind(f_o,'�ɱ��ṹ>');
    f=f_o(table_idx);
    [~,~,~,~,amt]=regexpi(f,'������ͨ�ɱ�\(��\).*(?\d+.?\d*)','match');
    if isempty(amt)
        [~,~,~,~,amt]=regexpi(f,'������ͨ�ɱ�\(��\).*?(\d+.?\d*)','match');
        f10{idx}.amountall=str2double(amt{1})*1e4;
    else
        f10{idx}.amountall=str2double(amt{1})*1e8;
    end
    table_idx=strfind(f_o,'�������>'):strfind(f_o,'��������>');
    f_share=f_o(table_idx);
    share_idx1_all=regexpi(f_share,',ÿ\d+��.*?\d{4}-\d{2}-\d{2}');
    
    f10{idx}.shareratio=zeros(6,length(share_idx1_all));
    for idx2=1:length(share_idx1_all)
        share_idx1=share_idx1_all(idx2);
        if idx2~=length(share_idx1_all)
            f_seg=f_share(share_idx1_all(idx2):share_idx1_all(idx2+1));

        else
            f_seg=f_share(share_idx1_all(idx2):end);
        end
        %ÿx����xԪ��x��ת��x��
        share_idx2=regexpi(f_seg,'��\d');
        share_idx3=regexpi(f_seg,'��\d');
        share_idx4=regexpi(f_seg,'ת��\d');
        share_idx5=regexpi(f_seg,'��\d');
        share_idx6=regexpi(f_seg,'��ɼ�\d');
        date_idx=strfind(f_seg,'��Ϣ��');
        if isempty(date_idx)
            date_idx=strfind(f_seg,'��Ȩ��');
        end
        if isempty(date_idx)
            date_idx=1;
        end
        date_temp=regexpi(f_seg(date_idx:end),'\d{4}.\d+.\d+','match');
        date_temp=date_temp(1);
        year=regexpi(date_temp,'\d{4}','match');
        date_temp=regexprep(date_temp,'[����]','-');
        month=regexpi(date_temp,'-\d+-','match');
        day=regexpi(date_temp,'-\d+','match');
%         day=day(end);
        f10{idx}.sharedate{idx2}=[month{1}{1}(2:end-1) '/' day{1}{end}(2:end) '/' year{1}{1}];
        if ~isempty(share_idx1)
            share_temp1=regexpi(f_seg,'\d+\.*\d*','match');
            f10{idx}.shareratio(1,idx2)=str2double(share_temp1(1));
        else
            f10{idx}.shareratio(1,idx2)=0;
        end
        if ~isempty(share_idx2)
            share_temp2=regexpi(f_seg(share_idx2:end),'\d+\.*\d*','match');
            f10{idx}.shareratio(2,idx2)=str2double(share_temp2(1));
        else
            f10{idx}.shareratio(2,idx2)=0;
        end
        if ~isempty(share_idx3)
            share_temp3=regexpi(f_seg(share_idx3:end),'\d+\.*\d*','match');
            f10{idx}.shareratio(3,idx2)=str2double(share_temp3(1));
        else
            f10{idx}.shareratio(3,idx2)=0;
        end
        if ~isempty(share_idx4)
            share_temp4=regexpi(f_seg(share_idx4:end),'\d+\.*\d*','match');
            f10{idx}.shareratio(4,idx2)=str2double(share_temp4(1));
        else
            f10{idx}.shareratio(4,idx2)=0;
        end
        if ~isempty(share_idx5)
            share_temp5=regexpi(f_seg(share_idx5:end),'\d+\.*\d*','match');
            f10{idx}.shareratio(5,idx2)=str2double(share_temp5(1));
        else
            f10{idx}.shareratio(5,idx2)=0;
        end
        if ~isempty(share_idx6)
            share_temp6=regexpi(f_seg(share_idx6:end),'\d+\.*\d*','match');
            f10{idx}.shareratio(6,idx2)=str2double(share_temp6(1));
        else
            f10{idx}.shareratio(6,idx2)=0;
        end
 
    end
    
    %�����Ƿֺ����
    
end


%��Ȩ��Ϣ��=(��Ȩ�Ǽ��յ����̼ۣ�ÿ�����ֺ����ֽ��+��ɼۡ�ÿ�������)��(1+ÿ���ͺ����+ÿ�������)
%��ɳ�Ȩ��=����Ȩ�Ǽ������̼�+��ɼ�*ÿ����ɱ�����/��1+ÿ����ɱ�����
