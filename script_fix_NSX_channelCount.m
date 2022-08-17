function script_fix_NSX_channelCount(Nch,f)
if nargin<1
Nch=32;
end
if nargin<2
    [f,p]=uigetfile('*.ns6');
    cd(p);
end 
f_fix=[f(1:end-4) '.dat'];
%%
NSX=openNSx([f]);
channelList=double([NSX.ElectrodesInfo(:).ElectrodeID]);

%% resample

if(iscell(NSX.Data))
    data=cellfun(@(x) resample(double(x'),20e3,30e3)',NSX.Data,'uni',0);
else
    data={resample(double(NSX.Data'),20e3,30e3)'};
end


%% save time info
TimeStamp=round(NSX.MetaTags.Timestamp*20e3/30e3);
Duration=cellfun(@(x) size(x,2),data);
save([p f(1:end-4) '_timestamp.mat'],'TimeStamp','Duration');

data=cat(2,data{:});
Len=max(size(data,2),20e3*60*10);
data_new=ones(Nch,Len);
data_new(channelList,1:size(data,2))=data;

sav2dat_embed(f_fix,data_new);

%%
function sav2dat_embed(fname,data,append_mode)
if nargin<3
    append_mode=0;
end
if append_mode==0
    mode='w+';
else
    mode='a+';
end

if size(data,2)<size(data,1)
    data=data';
end
fh=fopen(fname,mode);
fwrite(fh,data,'int16');
fclose(fh);

