% clear all;
close all;
clc;

% V=(imread('test.jpg'));
% V=double(rgb2gray(V));
% imshow(mat2gray(V));
load_pic;
V=data;

[i u]=size(V);                                    %����V�Ĺ��
r=15;                                  %���÷ֽ�������
W=rand(i,r);                            %��ʼ��WH��Ϊ�Ǹ���
H=rand(r,u);
maviter=500;                                    %����������
for iter=1:maviter
    W=W.*((V./(W*H))*H');           %ע�������������ʽ�����е��Ƕ�Ӧ��
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