[f_all,p]=uigetfile('*.ns6','multiselect','on');
if(~iscell(f_all))
    f_all={f_all};
end
for f_idx=1:length(f_all)
    f=f_all{f_idx};
    disp(['Processing:' num2str(f_idx) '/' num2str(length(f_all)) ' ' f])
    NSX=openNSx([p f]);
    %% resample data to 20KHz
    if(iscell(NSX.Data))
        data=cellfun(@(x) resample(double(x'),20e3,30e3)',NSX.Data,'uni',0);
    else
        data={resample(double(NSX.Data'),20e3,30e3)'};
    end
    %% save time info
    TimeStamp=round(NSX.MetaTags.Timestamp*20e3/30e3);
    Duration=cellfun(@(x) size(x,2),data);
    save([p f(1:end-4) '_timestamp.mat'],'TimeStamp','Duration');
    
    %% save to binary data format
    data=cat(2,data{:});
    fname=[p f(1:end-4),'.dat'];
    fh=fopen(fname,'w+');
    fwrite(fh,data,'int16');
    fclose(fh);
end