%Stock analysis code
%This script is aimed for analysis of 1-minute data
%20160419
p_start='E:\stock\day\';
cd(p_start);
[f_all,p]=uigetfile('*.txt','Select dayline data for stock analysis','multiselect','on');

days=round(linspace(1,10,3));

if f_all==0
    flist=dir('*.txt');
    f_all=arrayfun(@(x) x.name,flist,'UniformOutput',0);
    p=p_start;
    h=figure('visible','off');
else
    if ~iscell(f_all)==1
        f=f_all;
        f_all={f};
    end
    h=figure(1);
end
predicted=cell(length(f_all),1);
%%
multiWaitbar('stocks',0);
for f_idx=1:length(f_all)
    multiWaitbar('stocks',f_idx/length(f_all));
    stock=[];
    f=f_all{f_idx};
    data=importdata([p f]);
    try
        if isstruct(data)
            if length(data.data)>100
                stock.date=cellfun(@(x) datenum(x,'mm/dd/yyyy'),data.textdata(1:end-1));
                stock.data=data.data(:,1:end); %开 高 低 收 量 价
                
                %% parameter setting
                win=10;
                step=10;
                L=size(stock.data,1);
                % data preparition
                price=stock.data(:,4);
                % rate=(stock.data(:,4)-stock.data(:,1))./stock.data(:,1);
                % rate_range=(mean(stock.data(:,2:3),2)-stock.data(:,1))./stock.data(:,1);
                rate=bsxfun(@minus,stock.data(2:end,1:4),stock.data(1:end-1,4));
                rate=bsxfun(@rdivide,rate,stock.data(1:end-1,4));
                rate=[ 0 0 0 0; rate];
                % P_rate=abs(awt_freqlist_multirow(rate,100,1:20,'Gabor'));  %wavelet version
                macd_win=[1:10:100];
                P_rate_cell=arrayfun(@(x) filter(ones(1,x)/x,1,rate),macd_win,'UniformOutput',0);  %MACD
                % volume=zscore(stock.data(:,5));
                volume=stock.data(:,5);
                amount=stock.data(:,6);
                adj_amount=price.*volume;
                amount_diff=adj_amount-amount;
                % P_volume=abs(awt_freqlist(volume,100,1:20,'Gabor'));
                P_amount_cell=arrayfun(@(x) filter(ones(1,x)/x,1,amount),macd_win,'UniformOutput',0);  %MACD
                
                idx_mat=bsxfun(@plus,(1:step:L-win+1)',(0:win-1));
                price_mat=price(idx_mat);
                volume_mat=volume(idx_mat);
                open=rate(:,1);
                ending=rate(:,4);
                high=rate(:,2);
                low=rate(:,3);
                open_mat=open(idx_mat);
                close_mat=ending(idx_mat);
                high_mat=high(idx_mat);
                low_mat=low(idx_mat);
                % rate_mat=rate(idx_mat,:);
                % rate_range_mat=rate(idx_mat);
                amount_mat=amount_diff(idx_mat);
                % wavelet transform
                
                
                %
                % %% standarization ------------------------------------------method 1
                % price_mat=bsxfun(@rdivide,price_mat,price_mat(:,1));
                % % volume_mat=volume_mat;
                % % analysis_mat=price_mat;
                % analysis_mat=cat(2,open_mat,close_mat,high_mat,low_mat,amount_mat);
                % % analysis_mat=cat(2,rate,P_volume);
                % tag=[price(win:end) ;price(end)];
                % tag=diff(tag)./tag(1:end-1);
                % tag=tag(1:step:end);
                % % run t-sne to see pattern
                % mappedX=tsne(analysis_mat,tag,30,30);
                % %-----------------------------------------------------------EOF method 1
                
                %% standarization ------------------------------------------method 2
                price_mat=bsxfun(@rdivide,price_mat,price_mat(:,1));
                % volume_mat=volume_mat;
                % analysis_mat=price_mat;
                % P_rate_cell=arrayfun(@(x) P_rate(:,:,x),1:size(P_rate,3),'UniformOutput',0);
                P_rate_2d=cat(2,P_rate_cell{:});
                P_amount_2d=cat(2,P_amount_cell{:});
                analysis_mat=cat(2,P_rate_2d,P_amount_2d);
                analysis_mat=zscore(analysis_mat,[],1);
                p_day=0;
                tag=price;
                % run t-sne to see pattern
                % mappedX=tsne(analysis_mat(1:end-p_day,:),tag(p_day+1:end),30,30);
                %-----------------------------------------------------------EOF method 2
                %%
                % figure('Name','Rate plot');
                % densityPlot(mappedX(:,1),mappedX(:,2),tag,200);
                % hold on;
                % gscatter(mappedX(:,1), mappedX(:,2), tag);
                % % scatter(mappedX(:,1), mappedX(:,2),5, tags,'filled');
                % hold off;
                % axis tight
                % glm
                
                
                predicted_values=cell(length(days),1);
                for d_idx=1:length(days)
                    subplot(length(days),1,d_idx);
                    N_analysis=size(analysis_mat,1);
                    offset=0;
                    p_day=days(d_idx);
                    train_set=analysis_mat(1:end-p_day-offset,:);
                    train_tag=tag(p_day+1:end-offset);
                    % idx_sel=1:length(train_set);
                    idx_sel=randperm(size(train_set,1));
                    idx_sel=sort(idx_sel(1:round(0.8*size(train_set,1))))';
                    mdl = GeneralizedLinearModel.fit(train_set(idx_sel,:),train_tag(idx_sel));
                    tag_fitted=feval(mdl,analysis_mat);
                    plot(1:length(tag),tag);
                    hold on;
                    plot((1:length(tag))+p_day,tag_fitted,'r');
                    hold off;
%                     axis tight
                    xlim([length(tag)+max(days)-200 length(tag)+max(days)]);
                    title([f ' 预测' num2str(p_day) '天']);
                    predicted_values{d_idx}=tag_fitted(end-p_day:end);
                    %     legend('前复权日线','预测值');
                end
                saveas(h,[f(1:end-3) 'jpg'])
                predicted{f_idx}.name=f;
                predicted{f_idx}.value=predicted_values;
                predicted{f_idx}.data=tag;
                predicted{f_idx}.fitted=tag_fitted;
            end
        end
    catch
    end
end
%% rate ranking
predicted_filled=predicted(~cellfun(@isempty,predicted));
rate_predict_name=cellfun(@(x) x.name,predicted(~cellfun(@isempty,predicted)),'UniformOutput',0);

rate_predict=cell(length(days),1);
for d_idx=1:length(days);
    temp=cellfun(@(x) (x.value{d_idx}(2:end)-x.value{d_idx}(1))./x.value{1}(1),predicted_filled,'UniformOutput',0);
    rate_predict{d_idx}=cat(2,temp{:})';
end
evaluate_mat=cellfun(@(x) x(:,1),rate_predict,'UniformOutput',0);
evaluate_mat=cat(2,evaluate_mat{:});
evaluate_mat=mean(evaluate_mat,2)./std(evaluate_mat,[],2);
[~,ix]=sort(rate_predict{1},'descend');
rate_predict=cellfun(@(x) x(ix,:),rate_predict,'UniformOutput',0);
rate_predict_name=rate_predict_name(ix);
%%
save

