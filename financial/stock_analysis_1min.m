%Stock analysis code 
%This script is aimed for analysis of 1-minute data
%20160419
p_start='E:\stock\1min';
cd(p_start);
[f,p]=uigetfile('*.txt','Select 1-min data for stock analysis');
data=importdata([p f]);

datetxt=arrayfun(@(x) [data.textdata{x} ' ' num2str(floor(data.data(x,1)/100),'%0.2d') ':' num2str(mod(data.data(x,1),100))],...
    1:size(data.data,1),'UniformOutput',0);
stock.date=cellfun(@(x) datenum(x,'mm/dd/yyyy HH:MM'),datetxt);
stock.data=data.data(:,2:end); %开 高 低 收 量 价

%% parameter setting
win=300;
step=10;
L=size(stock.data,1);
% data preparition
price=stock.data(:,4);
rate=(stock.data(:,4)-stock.data(:,1))./stock.data(:,1);
rate_range=(mean(stock.data(:,2:3),2)-stock.data(:,1))./stock.data(:,1);
% volume=zscore(stock.data(:,5));
volume=stock.data(:,5);
P_volume=abs(awt_freqlist(volume,100,1:10,'Gabor'));
idx_mat=bsxfun(@plus,(1:step:L-win+1)',(0:win-1));
price_mat=price(idx_mat);
volume_mat=volume(idx_mat);
rate_mat=rate(idx_mat);
rate_range_mat=rate(idx_mat);
% wavelet transform



% standarization
price_mat=bsxfun(@rdivide,price_mat,price_mat(:,1));
% volume_mat=volume_mat;
% analysis_mat=price_mat;
% analysis_mat=cat(2,rate_mat,volume_mat);
analysis_mat=cat(2,rate,P_volume);
% tag=[price(win:end) ;price(end)];
% tag=diff(tag)./tag(1:end-1);
% tag=tag(1:step:end);
%% run t-sne to see pattern
mappedX=tsne(analysis_mat,price,10,10);

%% glm
% glm_win=500;
% N_analysis=size(analysis_mat,1);
% offset=-199:1:0;
% for t_idx=1:length(offset)
% sel_trials=N_analysis(1:N_analysis-offset(t_idx),:);
% mdl = GeneralizedLinearModel.fit(analysis_mat(sel_trials,:),tag(sel_trials));
% tag_fitted=feval(mdl,analysis_mat);
% plot(tag);
% hold on;
% plot(tag_fitted,'r');
% hold off;