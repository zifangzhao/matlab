%stock analysis with SVM
idx=6;
disp(stock{idx}.file);
day_pre=5;
day_fft=10;

day_to_analysis=300;
day_shift=0;
data_set=stock{idx}.data(end-day_to_analysis-day_shift:end-day_shift,[2 5 6]);
zero_loc=find(data_set(:,1)==0);
data_set(zero_loc,:)=[];
day_range=length(data_set)-day_pre-day_fft;  %fft需要掐掉数据头部
% data_set=data_set./repmat(mean(data_set,1),size(data_set,1),1);

%% data transform
fft_idx=1:size(data_set,1)-day_fft;
data_set_fft=cell2mat(reshape((arrayfun(@(x) reshape(abs(fft(data_set(x:x+day_fft,:),day_fft+1,1)),1,[]),fft_idx,'UniformOutput',0)),[],1));
data_set_fft=data_set_fft-repmat(min(data_set_fft,[],1),size(data_set_fft,1),1);
data_set_fft=((data_set_fft./repmat(max(data_set_fft,[],1),size(data_set_fft,1),1)));
% percent_class=;
%% prepare for the training
train_ratio=0.7;
% perm_list=randperm(size(data_set_fft-day_pre,1));
perm_list=1:size(data_set_fft-day_pre);
train_set=data_set_fft(perm_list(1:round(day_range.*train_ratio)),:);
train_class=((data_set(day_fft+1+day_pre:round(day_range.*train_ratio)+day_pre+day_fft,2)-data_set(1+day_fft+day_pre-1:round(day_range.*train_ratio+day_fft+day_pre-1),2))...
    ./data_set(1+day_fft+day_pre-1:round(day_range.*train_ratio+day_fft+day_pre-1),2));
train_class=double(train_class>0);
valid_set=data_set_fft(perm_list(round(day_range.*train_ratio)+1:day_range),:);
valid_class=((data_set(round(day_range.*train_ratio)+1+day_pre+day_fft:end,2)-data_set(round(day_range.*train_ratio)+1+day_fft+day_pre-1:day_range+day_fft+day_pre-1,2))...
    ./data_set(round(day_range.*train_ratio)+1+day_fft+day_pre-1:day_range+day_fft+day_pre-1,2));
valid_class=double(valid_class>0);
predict_set=data_set_fft(day_range+1:end,:);
predict_class=zeros(size(predict_set,1),1);
%% SVM training
libsvm_str=libsvmtrain(train_class,train_set,'-s 1 -t 2 -q -d 3 -h 0 -e 0.00001 ');
[valid,valid_accuracy,valid_dec_values]=svmpredict(valid_class,valid_set,libsvm_str);


%% SVM predicting
[predict,predict_accuracy,predict_dec_values]=svmpredict(predict_class,predict_set,libsvm_str);

%% matlab SVM training
% svmStruct = svmtrain(train_set,train_class,'kernel_function','linear','method','QP');
% valid_group=svmclassify(svmStruct,valid_set);
% accuracy=length(find(valid_class==valid_group))./length(valid_group)