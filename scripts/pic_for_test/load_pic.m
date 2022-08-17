%load pictures
files=dir('*.jpg');
pic=cell(length(files),1);
for idx=1:length(files)
    temp=imread(files(idx).name);
    if length(size(temp))>2
        temp2=double(rgb2gray(temp));
    else
        temp2=double(temp);
    end
    pic{idx}=reshape(temp2,1,[]);
end

data=(cell2mat(pic));