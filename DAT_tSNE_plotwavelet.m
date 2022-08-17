%% dat t-sne plot wavelet
[x,y]=ginput(1);
d=pdist2([x,y],mappedX);
[~,idx_sel]=find(bsxfun(@minus,d,min(d,[],2))==0);
map_sel=mappedX(idx_sel,:);
figure()
% subplot(121)
% imagesc(data_wave_all(idx_sel,:));
% subplot(122)
% plot(data_all{idx_sel});

data_LFP=data_all{idx_sel};
data_r=range(data_LFP,1);
fs=1000;
t=(0:length(data_LFP)-1)/fs;
offset=zeros(length(data_r),1);
offset(1)=0.5*data_r(1);
for idx=2:length(data_r)
    offset(idx)=offset(idx-1)+data_r(idx-1)/2+data_r(idx)/2;
end
plot(t,bsxfun(@minus,(data_LFP/1000)',offset/1000));