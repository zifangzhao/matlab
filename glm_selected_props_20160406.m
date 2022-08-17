%GLM fitting script for laser data
uiload %load calculated Xcorr data
%% standerdization
AmpV_norm=AmpV;
AmpC_norm=AmpC;
fname_unique=unique(fname);
for f_idx=1:length(fname_unique)
    same_idx=find((cellfun(@(x) isequal(x,fname_unique{f_idx}),fname)));
    temp=median(cat(3,AmpV{same_idx,1}),3);
    temp_std=std(cat(3,AmpV{same_idx,1}),[],3);
    temp2=cellfun(@(x) (x-temp)./temp_std,AmpV(same_idx,:),'UniformOutput',0);
    AmpV_norm(same_idx,:)=temp2;
    
    temp=median(cat(5,AmpC{same_idx,1}),5);
    temp_std=std(cat(5,AmpC{same_idx,1}),[],5);
    temp2=cellfun(@(x) (x-temp)./temp_std,AmpC(same_idx,:),'UniformOutput',0);
    AmpC_norm(same_idx,:)=temp2;
end


%%
f_1d=@(x) reshape(x,1,[]);
AmpC_1d=cellfun(f_1d,AmpC_norm,'UniformOutput',0);
AmpV_1d=cellfun(f_1d,AmpV_norm,'UniformOutput',0);
AmpMerge=cellfun(@(x,y) [x y],AmpC_1d,AmpV_1d,'UniformOutput',0);
AmpMerge=cellfun(@nan2zero,AmpMerge,'UniformOutput',0);

tags=zeros(length(fname),1);
mask=zeros(length(fname),1);
mask1=zeros(length(fname),1);
tags(cellfun(@(x) ~isempty(strfind(x,'ctrl')),fname))=1;
tags(cellfun(@(x) ~isempty(strfind(x,'pain')),fname))=2;
% mask(cellfun(@(x) ~isempty(strfind(x,'Rat6')),fname))=1;
% mask1(cellfun(@(x) isempty(strfind(x,'Rat12')),fname))=1;
empty_trial=cellfun(@isempty,AmpC);
tags(empty_trial(:,1))=0;
rat_num=cellfun(@(x) str2double(regexpi(x,'(?<=Rat)\d+?(?=_)','match')),fname);
% tags=tags.*(ismember(rat_num,[ 16]));

% pain_score=tags-1; %0 for ctrl, 1 for pains

Amp_ctrl_pre=cat(1,AmpMerge{tags==1,1});
Amp_ctrl_post=cat(1,AmpMerge{tags==1,2});
Amp_pain_pre=cat(1,AmpMerge{tags==2,1});
Amp_pain_post=cat(1,AmpMerge{tags==2,2});

Amp_all=cat(1,Amp_ctrl_pre,Amp_pain_pre,Amp_ctrl_post,Amp_pain_post);
%eliminate all column with only one value;
Amp_all_std=std(Amp_all,[],1);
fname_all=[fname(tags==1); fname(tags==1) ;fname(tags==2); fname(tags==2)];
% vary_idx=Amp_all_std>0.1;Amp_all=Amp_all(:,vary_idx);
pain_score=[zeros(1,size(Amp_ctrl_pre,1))...
    zeros(1,size(Amp_pain_pre,1))...
    zeros(1,size(Amp_ctrl_post,1))...
    1*ones(1,size(Amp_pain_post,1))];

%% Coeff name generator
nameC=cell(length(Location_name),length(Location_name),length(Freq_bands_name),length(Freq_bands_name));
% nameV=cell(length(Freq_bands_name),length(Location_name));
for loc1=1:length(Location_name)
    for loc2=1:length(Location_name)
        [x,y]=meshgrid(1:length(Freq_bands),1:length(Freq_bands));
        nameC(loc1,loc2,:,:)=arrayfun(@(x,y) [Location_name{loc1} '_' Location_name{loc2} '_'...
            Freq_bands_name{x} '_' Freq_bands_name{y}],x,y,...
            'UniformOutput',0);
    end
end
[a,b]=meshgrid(1:length(Freq_bands_name),1:length(Location_name));
nameV=arrayfun(@(x,y) [Freq_bands_name{x} '_' Location_name{y}],a,b,'UniformOutput',0);
f_1d=@(x) reshape(x,1,[]);
nameC_1d=f_1d(nameC);
nameV_1d=f_1d(nameV);
feature_name=[nameC_1d nameV_1d];


%% run PCA on input params 
% dim=30;
% [Amp_COMP,M,lamda]=pca(Amp_all,dim);
% [COEFF,SCORE] = princomp(Amp_all);
Amp_COMP=Amp_all(:,selected_props);
% Amp_PCA=SCORE(:,1:dim);
%% GLM fitting
mdl=GeneralizedLinearModel.fit(Amp_COMP,pain_score,'linear','distr','normal');

% uisave({'mdl','M','dim'},'GLM_fitted')
% glm ploting
% plotSlice(mdl)
% plotDiagnostics(mdl)
% plotResiduals(mdl)
% plotResiduals(mdl,'fitted')
% plotResiduals(mdl,'probability')
%
figure();

X=mdl.Coefficients.SE(2:end);
Y=mdl.Coefficients.pValue(2:end);
% sel_idx=X>prctile(X,80)&Y<0.5;
% X=X(sel_idx)./max(X);
% Y=Y(sel_idx);
plot(1:size(X,1),X);hold on
plot(1:size(Y,1),Y,'r');hold off
legend('SE','p-value');
set(gca,'Xtick',1:size(X,1));
set(gca,'Xticklabel',feature_name(selected_props));
% set(gca,'Xtick',1:size(X,1));
% set(gca,'Xticklabel',feature_name(sel_idx));
% plot(mdl.Coefficients.SE)
% plotyy(1:size(X,1),X,1:size(Y,1),Y);

% confint = coefCI(mdl) ;%See if some 95% confidence intervals for the coefficients include 0. If so, perhaps these model terms could be removed
% evaluate fitting

figure()
predict_v=feval(mdl,Amp_COMP);
plot(predict_v)
hold on;
plot(pain_score,'r');
hold off
uisave({'mdl'},'GLM_fitted');
%%
% fitting using most significant parameters
mdl1=GeneralizedLinearModel.fit(Amp_COMP(:,sel_idx),pain_score,'linear','distr','normal');
uisave({'mdl1','sel_idx'},'GLM_fitted_few')
%

figure();
X=mdl1.Coefficients.SE(2:end);
Y=mdl1.Coefficients.pValue(2:end);
plot(1:size(X,1),X);hold on
plot(1:size(Y,1),Y,'r');hold off
legend('SE','p-value');
set(gca,'Xtick',1:size(X,1));
set(gca,'Xticklabel',feature_name(sel_idx));
% plot(mdl.Coefficients.SE)
% plotyy(1:size(X,1),X,1:size(Y,1),Y);

% confint = coefCI(mdl) ;%See if some 95% confidence intervals for the coefficients include 0. If so, perhaps these model terms could be removed
%evaluate fitting

figure()
predict_v=feval(mdl1,Amp_COMP(:,sel_idx));
plot(predict_v)
hold on;
plot(pain_score,'r');
hold off
