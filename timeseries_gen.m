function [dataA,dataB,stp]=timeseries_gen(time_series,sort_prc,eli_prc,analysis_stp)
% 2013-10-18 revised by zifang zhao 修正排序依据，通过median-mean判断改变的方向
% 2013-03-11 revised by zifang zhao 增加排序依据时间
% 2012-12-24 revised by zifang zhao 增加差分图,增加结果输出
% 2012-11-1  revised by zifang zhao 修正边缘nan,增加对带权值的数据的支持
% 2012-10-27 created by zifang zhao
% uiopen()
% dataB=[];
% ts_cell=cell2mat(cellfun(@(x) max(x.dataA',[],1),time_series,'UniformOutput',0));
len_st_A=cellfun(@(x) size(x.dataA,1),time_series);
max_len_st_A=max(len_st_A);
len_st_B=cellfun(@(x) size(x.dataB,1),time_series);
max_len_st_B=max(len_st_B);

len_dl_A=cellfun(@(x) size(x.dataA,2),time_series);
max_len_dl_A=max(len_dl_A);
len_dl_B=cellfun(@(x) size(x.dataB,2),time_series);
max_len_dl_B=max(len_dl_B);

button=questdlg('Do you want to select weighted data?','Data selection');
switch button
    case 'Yes'
        dataA_all=cellfun(@(x)  intp(x.dataA_weighted,max_len_st_A,max_len_dl_A),time_series,'UniformOutput',0);
        dataB_all=cellfun(@(x)  intp(x.dataB_weighted,max_len_st_B,max_len_dl_B),time_series,'UniformOutput',0);
    case 'No'
        dataA_all=cellfun(@(x)  intp(x.dataA,max_len_st_A,max_len_dl_A),time_series,'UniformOutput',0);
        dataB_all=cellfun(@(x)  intp(x.dataB,max_len_st_B,max_len_dl_B),time_series,'UniformOutput',0);
    case 'Cancel'
        return
end

loc=find(len_st_B==max_len_st_B);
stp=time_series{loc(1)}.startpoint;


dataA=cell2mat(cellfun(@(x) max_value(x)',dataA_all,'UniformOutput',0)')';
dataB=cell2mat(cellfun(@(x) max_value(x)',dataB_all,'UniformOutput',0)')';

button=questdlg('Do you want to proceed with standardization?','Data processing...');
switch button
    case 'Yes'
        dataA=dataA./repmat(sum(dataA,2),[1 size(dataA,2)]);
        dataB=dataB./repmat(sum(dataB,2),[1 size(dataB,2)]);
    case 'No'

    case 'Cancel'
        return
end
dataA_o=dataA;
dataB_o=dataB;
[~,stp_idx]=min(abs(stp-analysis_stp));
if isempty(stp_idx)
    stp_idx=1;
end
dataA=dataA(:,stp_idx:end);
dataB=dataB(:,stp_idx:end);
% ix_eli_A=find(std(dataA,[],2)<prctile(std(dataA,[],2),eli_prc));
% ix_eli_B=find(std(dataB,[],2)<prctile(std(dataB,[],2),eli_prc));
ix_eli_A=elimination(dataA_all,eli_prc);
ix_eli_B=elimination(dataA_all,eli_prc);

x=1:size(dataA,1);
orderA=arrayfun(@(x) findidx(dataA(x,:),sort_prc),x);
orderB=arrayfun(@(x) findidx(dataB(x,:),sort_prc),x);
[~,ixA]=sort(orderA);
[~,ixB]=sort(orderB);
ixA=ixA(arrayfun(@(x) ~sum(ismember(x,ix_eli_A)),ixA));
ixB=ixB(arrayfun(@(x) ~sum(ismember(x,ix_eli_B)),ixB));

dataA=dataA_o;
dataB=dataB_o;
figure(1)
imagesc(stp,1:length(ixA),dataA(ixA,:));

set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ixA));
tagsA=cellfun(@(x) x.tagA,time_series(ixA),'UniformOutput',0);
set(gca,'Yticklabel',tagsA);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
colorbar
axis ij;
result.A.data=dataA(ixA,:);
result.A.tags=tagsA;


%% 选择需要的数据
str = cellfun(@(x) x.tagA,time_series(ixA),'UniformOutput',0);
[s,v] = listdlg('PromptString','Select data fieldnames',...
    'SelectionMode','multiple',...
    'ListString',str);
ixA=ixA(s);
figure(2)
% imagesc(dataA(ixA,:));
imagesc(stp,1:length(ixA),dataA(ixA,:));
set(gca,'Ytick',1:length(ixA));
tags=cellfun(@(x) x.tagA,time_series(ixA),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
% set(gca,'FontSize',5);
colorbar
clear('str','s','v');

result.A_selected.data=dataA(ixA,:);
result.A_selected.tags=tags;

% subplot(212)
figure(3)
% imagesc(dataB(ixB,:));
imagesc(stp,1:length(ixB),dataB(ixB,:));
set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ixB));
set(gca,'Yticklabel',cellfun(@(x) x.tagB,time_series(ixB),'UniformOutput',0));
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
colorbar
axis ij;
% 
result.B.data=dataB(ixA,:);
result.B.tags=tagsA;

%% 选择需要的数据
str = cellfun(@(x) x.tagB,time_series(ixB),'UniformOutput',0);
[s,v] = listdlg('PromptString','Select data fieldnames',...
    'SelectionMode','multiple',...
    'ListString',str);
ixB=ixB(s);
figure(4)
% imagesc(dataB(ixB,:));
imagesc(stp,1:length(ixB),dataB(ixB,:));
set(gca,'Ytick',1:length(ixB));
tags=cellfun(@(x) x.tagB,time_series(ixB),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
% set(gca,'FontSize',5);
colorbar
result.B_selected.data=dataB(ixB,:);
result.B_selected.tags=tags;

%%plotting compared figures
figure(5)
subplot(2,2,1)
imagesc(stp,1:length(ixB),dataA(ixB,:));

set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ixB));
tags=cellfun(@(x) x.tagA,time_series(ixB),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
% colorbar
axis ij;
v=caxis;
subplot(2,2,2)
imagesc(stp,1:length(ixB),dataB(ixB,:));
set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ixB));
tags=cellfun(@(x) x.tagA,time_series(ixB),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
% colorbar
axis ij;
caxis(v);

subplot(2,2,[3 4])
% contourf(stp,1:length(ixA),dataB(ixA,:)-dataA(ixA,:));
% surf(stp,1:length(ixA),dataB(ixA,:)-dataA(ixA,:));shading('interp')
imagesc(stp,1:length(ixB),((dataB(ixB,:)-dataA(ixB,:))));x=caxis;caxis([0 x(2)]);
set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ixB));
tags=cellfun(@(x) x.tagA,time_series(ixB),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
colorbar
axis ij;
% caxis(v);

figure(6);
diff=dataB(:,stp_idx:end)-dataA(:,stp_idx:end);
pmat=double(median(diff,2)>mean(diff,2));pmat(pmat==0)=-1;
diff_abs=diff.*repmat(pmat,1,size(diff,2)); %median-mean >0 means pattern in increasing, otherwise, pattern is decreasing
loc_diff=zeros(1,size(diff_abs,1));
for idx=1:size(diff_abs,1)
    [~,y]=find(diff_abs(idx,:)>=prctile(diff_abs(idx,:),sort_prc));
    loc_diff(idx)=y(1);
end
[~,ix_diff]=sort(loc_diff);
ix_diff=ix_diff(arrayfun(@(x) ~sum(ismember(x,ix_eli_B)),ix_diff));
subplot(2,2,1)
imagesc(stp,1:length(ix_diff),dataA(ix_diff,:));
set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ix_diff));
tags=cellfun(@(x) x.tagA,time_series(ix_diff),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
% colorbar
axis ij;
v=caxis;
subplot(2,2,2)
imagesc(stp,1:length(ix_diff),dataB(ix_diff,:));
set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ix_diff));
tags=cellfun(@(x) x.tagA,time_series(ix_diff),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
% colorbar
axis ij;
caxis(v);

subplot(2,2,[3 4])
% contourf(stp,1:length(ixA),dataB(ixA,:)-dataA(ixA,:));
% surf(stp,1:length(ixA),dataB(ixA,:)-dataA(ixA,:));shading('interp')
imagesc(stp,1:length(ix_diff),((dataB(ix_diff,:)-dataA(ix_diff,:))));
% x=caxis;caxis([0 x(2)]);
set(gca,'YTickLabelMode','manual','YDir','normal', ...
    'Ytick',1:length(ix_diff));
tags=cellfun(@(x) x.tagA,time_series(ix_diff),'UniformOutput',0);
set(gca,'Yticklabel',tags);
% set(gca,'Xtick',1:7:length(stp),'Xticklabel',stp(1:7:end))
set(gca,'FontSize',5);
colorbar
axis ij;

result.startpoint=stp;
uisave('result','time_result');
end
% ts_cell=cell2mat(cellfun(@(x) mapminmax(max(x.dataA',[],1),[0 1]),time_series,'UniformOutput',0));
% imagesc(ts_cell);
function data=intp(time_series,max_len_st,max_len_dl)
if size(time_series,1)==1
    time_series=[time_series ; time_series];
    max_len_st=2;
    [x,y]=meshgrid(1:size(time_series,1),1:size(time_series,2));
    [xi,yi]=meshgrid(linspace(1,size(time_series,1),max_len_st),linspace(1,size(time_series,2),max_len_dl));
    % [xi,yi]=meshgrid((0:(max_len-1)).*(length(time_series)/(max_len+1)));
    
    data=interp2(x,y,time_series',xi,yi);
    data=data(:,1);
else
    if size(time_series,2)==1
        time_series=[time_series  time_series];
        max_len_dl=2;
        [x,y]=meshgrid(1:size(time_series,1),1:size(time_series,2));
        [xi,yi]=meshgrid(linspace(1,size(time_series,1),max_len_st),linspace(1,size(time_series,2),max_len_dl));
        % [xi,yi]=meshgrid((0:(max_len-1)).*(length(time_series)/(max_len+1)));
        
        data=interp2(x,y,time_series',xi,yi);
        data=data(1,:);
    else
        [x,y]=meshgrid(1:size(time_series,1),1:size(time_series,2));
        [xi,yi]=meshgrid(linspace(1,size(time_series,1),max_len_st),linspace(1,size(time_series,2),max_len_dl));
        % [xi,yi]=meshgrid((0:(max_len-1)).*(length(time_series)/(max_len+1)));
        data=interp2(x,y,time_series',xi,yi);
    end
end
end

function data=max_value(data)
data=max(data,[],1);
data(isnan(data))=0;
end

function idx=findidx(data,prc)
p=median(data)>mean(data);
p=double(p);
p(p==0)=-1;
data=data*p;
idx=find(data>=prctile(data,prc));
idx=idx(1);
end

function eli_idx=elimination(data_all,eli_prc)
stds=cellfun(@cal_std,data_all);
eli_idx=find(stds<prctile(stds,eli_prc));
end

function std_avg=cal_std(data)
[x,~]=find(data>prctile(reshape(data,[],1),95));loc=unique(x);
std_avg=mean(std(data(loc,:),[],1));
end