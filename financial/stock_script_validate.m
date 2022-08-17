%股票分析验证脚本
cd('e:\stock\');
days=500;
day_predict=10;
para_sel=[1 5];
predict_diff_all=zeros(10,10);
day_pre=1;
for par1=20
    fft_day=150;%ceil(0.3*days);
    offset=day_predict;
    % [stock predict_avg column selected_para]=stock_script_ga_all(para_sel,days,fft_day,day_predict,1000,20,2e-8,0);
    for par2=4
        [stock predict_avg column selected_para]=stock_script_ga_all_profit(days,fft_day,day_predict,day_pre,5000,100,2e-8,offset,20);
        predict_diff=0;
        for stk=1:length(stock)
            data_val=stock{stk}.data(end-day_predict:end,[1 5]);
            predict_val=stock{stk}.predict_raw;
%             predict_val=predict_val-repmat(min(predict_val,[],1),[day_predict+1 1]);
%             data_val=data_val-repmat(min(data_val,[],1),[day_predict+1 1]);
%             predict_val=predict_val./repmat(sum(predict_val,1),[day_predict+1 1]);
%             data_val=data_val./repmat(sum(data_val,1),[day_predict+1 1]);
            predict_diff=sum(reshape(abs(predict_val-data_val),[],1))+predict_diff       ;
            figure(1)
            for idx=1:2
                subplot(2,1,idx);hold off;
                plot(predict_val(:,idx),'r');hold on;plot(data_val(:,idx),'b');
            end
            pause()
        end
        predict(par1,par2)=predict_diff;
    end
end    
save(['stock_' num2str(para_sel) '_' date]);
% stock_gui;