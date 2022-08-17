%stock analysis with SVM
function stock=stock_svm()
%% read stock information
stock=stock_read_v2;
if matlabpool('size')==0
    matlabpool
end
parfor stock_idx=1:length(stock);
    fprintf(2,[stock{stock_idx}.name ' \n']);
    day_pre=5;
    day_fft=10; %偶数
    
    day_to_analysis=300;
    day_shift=0;
    data_set=stock{stock_idx}.data(end-day_to_analysis-day_shift:end-day_shift,[1 4 5 6]); %1:开盘 4：收盘 5：交易量 6：成交额
    zero_loc=find(data_set(:,1)==0);
    data_set(zero_loc,:)=[];
    day_range=length(data_set)-day_fft;  %可计算范围需要剪掉预测的天数和给FFT预留的数据
    % data_set=data_set./repmat(mean(data_set,1),size(data_set,1),1);
    
    %% data perparation
    fft_col=[3 4]; %需要进行FFT处理的列
    fft_idx=(1:day_range)+day_fft;
    data_set_fft=zeros(length(fft_idx),day_fft);
    for idx=1:length(fft_col)
        col=fft_col(idx);
        temp=cell2mat(reshape((arrayfun(@(x) fft_trans(data_set(x-day_fft:x,col),day_fft),fft_idx,'UniformOutput',0)),[],1));
        data_set_fft(:,(idx-1)*day_fft/2+1:idx*day_fft/2)=mapminmax(temp',1,2)';
    end
    % data_set_fft=reshape(data_set_fft,[],1);
    % data_set_fft=mapminmax(data_set_fft,1,2);
%     data_set_all=[ mapminmax(data_set(1+day_fft:day_fft+day_range,2)',1,2)' data_set_fft];
    day_range=day_range-day_pre;
    class_set_all=[mapminmax(data_set(1+day_fft+day_pre:day_fft+day_pre+day_range,1)',1,2)'];
%     data_set_all=[mapminmax(data_set(fft_idx,1)',1,2)' mapminmax(data_set(fft_idx,2)',1,2)' data_set_fft];
%     data_set_all=[mapminmax(data_set(fft_idx,[2 3 4])',1,2)'];
    data_set_all=data_set_fft;
    %% prepare for the training
    train_ratio=1;
    perm_list=randperm(size(data_set_all,1)-day_pre);
%     perm_list=1:size(data_set_all-day_pre);
    train_set=data_set_all(perm_list(1:round(day_range.*train_ratio)),:);
    train_class=class_set_all(perm_list(1:round(day_range.*train_ratio)),1);
    perm_list=1:size(data_set_all-day_pre);train_ratio=0;
    valid_set=data_set_all(perm_list(round(day_range.*train_ratio)+1:day_range),:);
    valid_class=class_set_all(perm_list(round(day_range.*train_ratio)+1:day_range),1);
    
    day_include=30;
    predict_set=data_set_all(day_range+1-day_include:end,:); %包括已知的前30天的数据
    predict_class=zeros(size(predict_set,1),1);
    
    predict_class(1:day_include)=class_set_all(end-day_include+1:end,1);
    predict_class(day_include:end)=predict_class(day_include);
    predict_class=mapminmax(predict_class',0,1)';
    %% SVM training
    [~, best_c best_g]=SVM_optimization(train_class,train_set,5,-10:10,-10:10,2);
    % libsvm_str=libsvmtrain(train_class,train_set,'-c 2 -g 1 -s 0 -t 1 -q');
    libsvm_str=libsvmtrain(train_class,train_set,['-c ' num2str(best_c) ' -g ' num2str(best_g) ' -s 3 -t 2 -q -e 0.0001']);
%     libsvm_str=libsvmtrain(train_class,train_set,'-s 3 -t 2');
    [valid,~,valid_dec_values]=svmpredict(valid_class,valid_set,libsvm_str);
    figure(1)
    valid=mapminmax(valid',0,1)';
    valid_class=mapminmax(valid_class',0,1)';
    subplot(211);plot(valid);title([stock{stock_idx}.name ' 训练结果']);
    subplot(212);plot(valid_class);title('实际行情');

    %
    %
    %% SVM predicting
    [svm_predict,~,predict_dec_values]=svmpredict(predict_class,predict_set,libsvm_str);
    figure(2)
    svm_predict=mapminmax(svm_predict',0,1)';
    subplot(211)
    plot(svm_predict);

    subplot(212)
    plot(predict_class,'r');
    stock{stock_idx}.predict=[svm_predict predict_class];
    stock{stock_idx}.valid=[valid valid_class];
end
end
%% matlab SVM training
% svmStruct = svmtrain(train_set,train_class,'kernel_function','linear','method','QP');
% valid_group=svmclassify(svmStruct,valid_set);
% accuracy=length(find(valid_class==valid_group))./length(valid_group)

function Y=fft_trans(X,day_fft)
Y=fft(X,day_fft+1,1);
Y=reshape(abs(Y(1:day_fft/2,:)),1,[]);
end