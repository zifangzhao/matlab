%stock ga plot
function state=stock_ga_plot_v2(options,state,flag,data,profit,fft_day,day_pre,name,selected_para,column,paras,levels)
%2013-7-5 revised from stock_ga_plot , 增加day_pre,改进加入st_h

for sbp=selected_para
    subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),sbp)
    plot(data(sbp,:));
    hold on;
    [~,i]=min(state.Score);
    p_all=state.Population{i};  %读入最好的参数

    p=p_all(1:end-size(data,1)*size(profit,2),:);%p的构成 【第一参数|第一参数 第一参数|第二参数| 第二参数|第一参数| 第二参数|第二参数 第一参数|筹码 第二参数|筹码】
    p2=p_all(1+end-size(data,1)*size(profit,2):end,:);
    
    post=zeros(size(data,2),1);
    idx=fft_day:size(data,2)-1;
    
%     post(idx)=arrayfun(@(x) sum(reshape([data(:,x-fft_day-day_pre+1:x-day_pre) mean(data(:,x-fft_day-day_pre+1:x-day_pre),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp)),idx);
    post(idx+day_pre)=arrayfun(@(x) sum([reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2) ],[],1) ; profit(x,:)']...
        .*[p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp) ; p2((sbp-1)*levels+1:sbp*levels)]),idx);

    plot(post,'r');
    title([name column{sbp} 'Gen: ' num2str(state.Generation)]);
    hold off;
end
% pause()