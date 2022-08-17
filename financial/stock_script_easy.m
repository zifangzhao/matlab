%¹ÉÆ±·ÖÎö½Å±¾
% cd('e:\stock\');
days=200;
day_predict=7;
para_sel=[1 5];
fft_day=60;
day_pre=5;%ceil(0.3*days);
% [stock predict_avg column selected_para]=stock_script_ga_all(para_sel,days,fft_day,day_predict,1000,20,2e-8,0);
[stock predict_avg column selected_para]=stock_script_ga_all_profit(days,fft_day,day_predict,day_pre,1000,100,2e-8,0,30);

save(['stock_' num2str(para_sel) '_' date]);
% stock_gui;