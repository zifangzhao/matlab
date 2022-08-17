files=dir('*.jpg');

pic =cell(length(files),1);
% img=arrayfun(@(x) importdata(x.name),files,'UniformOutput',0);
% img=cell(1,length(files));

multiWaitbar('Files:',0,'Color',[0.1 0.5 0.8])
for idx=1:length(files)
%     mov(idx)=im2frame(img{idx});
       pic{idx}=(importdata(files(idx).name));
       multiWaitbar('Files:',idx/length(files))
end

pic_enc=zeros(size(pic{idx}));
for idx=1:length(files)
    pic_enc=double(pic{idx})+pic_enc;
end
%pic_enc=log10(1+pic_enc);
pic_enc=pic_enc-min(reshape(pic_enc,1,[]));
pic_enc=pic_enc./max(reshape(pic_enc,1,[]));
% pic_enc=uint16(pic_enc);
imagesc(pic_enc(:,:));
% caxis([0.4,0.7])