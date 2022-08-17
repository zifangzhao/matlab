%% Ica weight displayer
function dispICA(normalize)
if nargin<1
    normalize=0;
end
[f p]=uigetfile('*_ICA.mat','Select ICA file','Multiselect','on');
if ~iscell(f)
    if normalize
        figure('Name',['ICA weights for file:' f ' Normalized'])
    else
        figure('Name',['ICA weights for file:' f])
    end
    mo=matfile([p f]);
    ICA_print(mo,f,[],normalize);
    
else
    fd=f;
    m=ceil(length(fd)^0.5);
    n=round(length(fd)^0.5);
    if normalize
        figure('Name',['ICA weights for folder:' p ' Normalized'])
    else
        figure('Name',['ICA weights for folder:' p])
    end
    
    for idx=1:length(fd)
        mo=matfile([p fd{idx}]);
        subplot(n,m,idx);
        ICA_print(mo,fd{idx},[],normalize);
    end
    %     if ~normalize
    
    %     end
end
clims=cell2mat(arrayfun(@(x) caxis(x),get(gcf,'children'),'UniformOutput',0));
c=max(abs([min(clims(:,1)) max(clims(:,2))]));
arrayfun(@(x) caxis(x,[-c c]),get(gcf,'children'));

function ICA_print(mo,titlename,clim,normalize)
Nch=mo.nbchan;
Nic=size(mo.icaweights,1);
w=ones(Nic,Nch);
chs=mo.icachansind;
if normalize
    w(1:Nic,chs)=zscore(mo.icaweights,[],2);
else 
    w(1:Nic,chs)=mo.icaweights;
end
% w(chs,chs)=log(abs(mo.icaweights));
imagesc((w));
axis tight
chs=1:4:size(w,2);
ICAs=1:4:size(w,1);
set(gca,'xtick',chs,'ytick',ICAs);
set(gca,'xticklabel',arrayfun(@(x) [num2str(x)],chs,'UniformOutput',0));
set(gca,'yticklabel',arrayfun(@(x) [num2str(x)],ICAs,'UniformOutput',0));
% set(gca,'xticklabel',arrayfun(@(x) [num2str(x) ' (' num2str(x-1) ')'],chs,'UniformOutput',0));
% set(gca,'yticklabel',arrayfun(@(x) [num2str(x) ' (' num2str(x-1) ')'],1:size(w,1),'UniformOutput',0));
ft=title(titlename,'Interpreter','none');
ylabel('ICA')
xlabel('channel')

% colorbar
if ~isempty(clim)
    caxis(clim)
else
    wlinear=reshape(w,1,[]);
    caxis([prctile(wlinear,1),prctile(wlinear,99)]);
end
% axis xy
% rotateticklabel(gca,90);