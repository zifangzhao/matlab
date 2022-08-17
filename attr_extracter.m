function attr=attr_extracter(name,label) %%从文件名中提取属性，以label为分隔符
%2012-4-18 revised by Zifang Zhao 增加对空输入的支持
%2012-4-15 revised by Zifang Zhao 增加对非文件名的支持,修正连续分隔号出现的空属性
dotloc=find(name=='.');
attr=[];
if isempty(dotloc)
else
    name=name(1:dotloc-1);
end
label_loc=0;
label_loc=[label_loc strfind(name,label)];
if length(label_loc)>1
    attr=cell(length(label_loc),1);
    for m=1:length(label_loc)-1
        attr{m}=name(label_loc(m)+1:label_loc(m+1)-1);
    end
    attr{m+1}=name(label_loc(m+1)+1:end);
else
    attr{1}=name;
end
%清除空的属性('__')的情况
n=1;
temp=[];
for idx=1:length(attr)
    if ~isempty(attr{idx})
        temp{n}=attr{idx};
        n=n+1;
    end
end
attr=temp';