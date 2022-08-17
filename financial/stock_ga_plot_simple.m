%stock ga plot
function state=stock_ga_plot_simple(options,state,flag)
fprintf(['Generation: ' num2str(state.Generation) ' Min_score= ' num2str(min(state.Score)) ' \n']);
title(['Generation: ' num2str(state.Generation) ' Min_score= ' num2str(min(state.Score)) ' \n']);
%plot raw data
% persistent num
% if isempty(num)
%     num=1;
% else
%     num=num+1;
% end
% for sbp=selected_para
%     subplot(ceil(length(selected_para)^0.5),round(length(selected_para)^0.5),sbp)
%     plot(data(sbp,:));
%     hold on;
%     [~,i]=min(state.Score);
%     p=state.Population{i};
%     post=zeros(size(data,2),1);
%     % for i=1+fft_day:size(data,2)
%     %     Y=data(:,i-fft_day+1:i);
%     % %         Y=abs(fft(data(:,i-fft_day+1:i)));
%     % %         Y=Y(1:ceil(end/2));
%     %     data_pre=[reshape(Y,[],1);reshape(mean(data(:,i-fft_day+1:i),2),[],1)]; %fft_day/2*p
%     %     post(i)=sum(data_pre.*p);
%     % end
%     idx=fft_day:size(data,2)-1;
%     % post(1+fft_day:end)=arrayfun(@(x) sum(reshape([abs(fft(data(:,x-fft_day+1:x))) mean(data(:,x-fft_day+1:x),2)],[],1).*p),idx);
%     post(1+fft_day:end)=arrayfun(@(x) sum(reshape([data(:,x-fft_day+1:x) mean(data(:,x-fft_day+1:x),2)],[],1).*p(end/size(data,1)*(sbp-1)+1:end/size(data,1)*sbp)),idx);
%     % post(1+fft_day:end)=mapminmax(post(1+fft_day:end)',0,1)';
%     plot(post,'r');
%     title([name column{sbp} 'Gen: ' num2str(state.Generation) ]);
%     hold off;
% end