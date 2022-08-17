file='G:\My Drive\data\HD32\Publication_files\Figure5F_source.jpg';
data=imread(file);
data=im2bw(data,0.5);
image(data)