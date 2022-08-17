%延展矩阵与CELL结构时间对比
data_seed=rand(100,1e5);
data=[];
%data_ext
tic
for idx=1:size(data_seed,1)
    data=[data data_seed(idx,:)];
end
fprintf(1,'time for extented matrix');
toc
%cell
tic
data_c=cell(1,size(data_seed,1));
for idx=1:size(data_seed,1)
    data_c{idx}=data_seed(idx,:);
end
data2=cell2mat(data_c);
toc