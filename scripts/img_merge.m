%image_merge
[filename pathname]=uigetfile('*.tif','*.jpg');
list=dir([pathname '*.tif']);
len=length(list);
Io=double(imread([pathname list(1).name]));
for idx = 2:len
    Io=Io+double(imread([pathname list(idx).name]));
end