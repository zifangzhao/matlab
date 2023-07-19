clc
clear
close all
I=imread('H:\exchange\cell counting\7d-11FC CGRP 20X 100ms-3.tif');
I=I(:,:,1);
% imshow(I);

bg=imopen(I,strel('disk',150));
% figure, surf(double(bg(1:8:end,1:8:end))),zlim([0 255]);
% set(gca,'ydir','reverse');
I2=I-bg;
% figure();
% imshow(I2);

I3=imadjust(I2);
% figure();
% imshow(I3);
level=graythresh(I3);
bw=im2bw(I3,level);

input=bw;
rmax=200;
% cell_judge
bw=bwareaopen(bw,200);
figure();
imshow(bw);
s=regionprops(bw,'BoundingBox','Eccentricity');
for m=length(s):-1:1
    if s(m).Eccentricity>0.9
        s(m)=[];
    end
end
bbox=cat(1,s.BoundingBox);
figure();
imshow(bw);
hold on
for num=1:size(bbox)[1];
rectangle('Position',[bbox(num,1),bbox(num,2),bbox(num,3),bbox(num,4)],...
    'Curvature',[0.8,0.4],'LineWidth',2,'LineStyle','--','EdgeColor','g')
end
hold off