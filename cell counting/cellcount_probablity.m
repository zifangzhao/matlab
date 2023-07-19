%2012-8-7
%cell counting algorithm by Zifang zhao inspired by Dusan. 
isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
channel=3;
level=0.59;
[filename pathname]=uigetfile('*.tif','*.jpg');
Io=imread([pathname,filename]);

% I=Io(:,:,channel);
trim=200:400;
I=Io(trim,trim,channel);
bw=edge(I,'prewitt');
% level = graythresh(I);
% bw=im2bw(I,level);
se=strel('disk',1,4);
bw2=imdilate(bw,se);
% se=strel('disk',1,4);
bw3=bwareaopen(bw2,100);
imshow(bw3)
bw=bw3;
cell_size=10;
cell_angle=cell_judge(bw,cell_size);
figure(1);imagesc(bw)
figure(2);imagesc(cell_angle)