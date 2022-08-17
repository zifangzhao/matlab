% [filename pathname]=uigetfile('*.mat');
% rawdata=load([pathname '\' filename]);
chans=channelpick(fieldnames(rawdata),'elec');

rawdata_valid=cell(length(chans),1);
for i = 1:length(chans)
    eval(['rawdata_valid{i} = rawdata.elec' num2str(chans(i)) ';']);
end
data=cell2mat(rawdata_valid');

idxs=190000;
idxe=idxs+5000;
len=idxe-idxs;
win=1e3;
skp=10;

mov(len/skp) = struct('cdata',[],'colormap',[]);

data=mapminmax(data,0,1);
c_max=max(reshape(data,[],1));
c_min=min(reshape(data,[],1));

multiWaitbar('Files:',0,'Color',[0.1 0.5 0.8])
for idx=1:len/skp
    imagesc(data(idxs+skp*idx:idxs+skp*idx+win,:)); axis xy;
    caxis([c_min c_max])
    mov(idx)=getframe();
    multiWaitbar('Files:',idx/len)
end



movie2avi(mov,['eeg_mov_5' ],'compression','None');
multiWaitbar('CloseAll');