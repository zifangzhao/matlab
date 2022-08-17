%%stock read all
start_dir='e:\stock';
cd(start_dir);
[f,p]=uigetfile('*.txt','Select file to be loaded','MultiSelect','on');
if ~iscell(f)
    temp=f;
    f=cell(1);
    f{1}=temp;
end
stock=cell(length(f),1);
multiWaitbar('Loading:',0);
for idx=1:length(f)
    data=importdata([p f{idx}]);
    try
        if isstruct(data)
            stock{idx}.date=cellfun(@(x) datenum(x,'mm/dd/yyyy'),data.textdata(1:end-1));
            stock{idx}.data=data.data(:,1:end); %开 高 低 收 量 价
        end
    end
    multiWaitbar('Loading:',idx/length(f));
end
multiWaitbar('Close all');
empty_idx=cellfun(@isempty,stock);
stock(empty_idx)=[];
stock_name=f;
stock_name(empty_idx)=[];
%% get all available date
date_all=cellfun(@(x) x.date,stock,'UniformOutput',0);
date_all=unique(cat(1,date_all{:}));
%% fill non-opening date with old data
stock=cellfun(@(x) stock_fix_date(x,date_all),stock,'UniformOutput',0);
%% concatinate all data into a matrix
stock_all=cellfun(@(x) x.data(:,[4 5]),stock,'UniformOutput',0);
stock_all=cat(2,stock_all{:})';

%% run ica
stockICA=pop_importdata('setname',f,'dataformat','array','data','stock_all','srate',1);
stockICA=pop_runica(stockICA,'icatype','runica','chanind',1:size(stock_all,1),'concatenate','off');
save([p  'stock_ICA.mat'],'-struct','stockICA');
%%
stock_ica = stockICA.icaweights*stockICA.icasphere*stock_all;