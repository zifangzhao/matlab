% clear all;
close all;
clc;

% V=(imread('test.jpg'));
% V=double(rgb2gray(V));
% imshow(mat2gray(V));
load_pic;
V=data;

[i u]=size(V);                                    %计算V的规格
r=15;                                  %设置分解矩阵的秩
W=rand(i,r);                            %初始化WH，为非负数
H=rand(r,u);
maviter=500;                                    %最大迭代次数
for iter=1:maviter
    W=W.*((V./(W*H))*H');           %注意这里的三个公式和文中的是对应的
    W=W./(ones(i,1)*sum(W));    
    H=H.*(W'*(V./(W*H)));          % No fitness function here
end
figure;
for idx=1:r
    subplot(4,4,idx)
%     img_V=W(:,idx)*H(idx,:);
    imshow(mat2gray(reshape(H(idx,:),300,300)))
%     imshow(mat2gray(img_V));
end
% figure()
% img_V=W*H;
% imshow(mat2gray(img_V));