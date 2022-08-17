%stock ga plot for eRAP
function state=stock_ga_plot_eRAP(options,state,flag,data,fft_day,name,selected_para,column)
[~,i]=min(state.Score);
p=state.Population{i};

idx=fft_day:size(data,2)-1;
related_para1=[1 3];
P=arrayfun(@(x) sum(reshape([data(related_para1,x-fft_day+1:x) mean(data(related_para1,x-fft_day+1:x),2)],[],1)...
    .*p(1:(fft_day+1)*2)),idx);

R= [diff([data(1,fft_day-1) P])] ./data(1,idx);
M=sign(data(2,:)).*(exp(abs(mapminmax(data(2,:),-1,1)))-1).*data(3,:);
related_para3=[1];
A=arrayfun(@(x) sum(reshape([data(related_para3,x-fft_day+1:x) mean(data(related_para3,x-fft_day+1:x),2) M(x-fft_day+1:x) mean(M(x-fft_day+1:x),2)],[],1)...
    .*p((fft_day+1)*2+1:end)),idx);
post=zeros(size(data,1),size(data,2));
post(1,fft_day+1:end)=P;
post(2,fft_day+1:end)=R;
post(3,fft_day+1:end)=A;
for sbp=selected_para
    subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),sbp)
    plot(data(sbp,:));
    hold on;

    plot(post(sbp,:),'r');
    title([name column{sbp} 'Gen: ' num2str(state.Generation)]);
    hold off;
end