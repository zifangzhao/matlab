function [best_acc,best_c,best_g]=SVM_optimization(train_label,train,v,c_range,g_range,base_num)
[C,G]=meshgrid(c_range,g_range);

% acc=zeros(size(C)); %记录准确率的矩阵

acc=arrayfun(@(c,g) libsvmtrain(train_label,train,['-v ',num2str(v),' -c ',num2str(base_num^c),' -g ',num2str(base_num^g) ' -s 3 -q']),C,G,'UniformOutput',0);
if ~isempty(acc)
    acc=cell2mat(acc);
    best_acc=max(reshape(acc,1,[]));
    max_loc=find(acc==best_acc);
    
    best_c=base_num^C(max_loc(1));
    best_g=base_num^G(max_loc(1));
else
    best_acc=[];
    best_c=[];
    best_g=[];
end