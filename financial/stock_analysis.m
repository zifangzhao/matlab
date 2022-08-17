col=4;
temp=cellfun(@(x) x.data(:,col),stock,'UniformOutput',0);
merge_data=zeros(size(temp,1),size(temp{1},1));
for idx=1:length(temp)
    merge_data(idx,:)=temp{idx};
end
imagesc(log10(1+merge_data))

idx=2;
figure(1);subplot(2,1,1);spectrogram(stock{idx}.data(:,col),50,40,'yaxis');subplot(2,1,2);plot(stock{idx}.data(:,1));