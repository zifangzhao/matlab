function [cent,s_std]=cluster_find(data,min_area,max_ecc,min_I,min_percent,plot_on)
%% created by Zifang zhao @ 2012-5-29 divide PCMI data into clusters and find out their centroids and std.
if nargin<6
    plot_on=0;
end
cent=[];
s_std=[];
% min_area=50;
% data=(Ixys{1,4}{15,27});
% dataI=data/max(reshape(data,1,[]));
datab=data>prctile(reshape(data,1,[]),min_percent)&data>min_I;
dataw=datab.*data;
% [xs,ys]=meshgrid(1:size(data,1),1:size(data,2));
% temp=arrayfun(@(x,y,z) [x,y,dataw(x,y)],xs,ys,'UniformOutput',0);
% temp=reshape(temp,[],1);
% x3=cell2mat(temp);

%% using regionprops to select ROI
s=regionprops(datab,data,'BoundingBox','WeightedCentroid','Area','Eccentricity');

if ~isempty(s)
    s_area=cat(1,s.Area);
    
    %     s=s(s_area==max(s_area));
    s=s(s_area>min_area);
    s_ecc=cat(1,s.Eccentricity);
    s=s(s_ecc<max_ecc);
    bbox=cat(1,s.BoundingBox);
    bboxf=floor(bbox);
    bboxf(bboxf==0)=1;
    cent=cat(1,s.WeightedCentroid);
    if plot_on==1
        figure(1);
        imagesc(data);
        hold on
    end
    s_std=zeros(1,length(bbox));
    for num=1:size(bbox,1);
        if plot_on==1
            rectangle('Position',[bbox(num,1),bbox(num,2),bbox(num,3),bbox(num,4)],...
                'Curvature',[0.8,0.4],'LineWidth',3,'LineStyle','--','EdgeColor','k')
            plot(cent(num,1),cent(num,2),'k*','LineWidth',1);
        end
        s_std(num)=std(reshape(data(bboxf(num,1):(bboxf(num,1)+bboxf(num,3)-1),bboxf(num,2):(bboxf(num,2)+bboxf(num,4)-1)),[],1));
    end
    
end
hold off;
% x3=[];
% for x=1:size(data,1);
%     for y=1:size(data,2);
%         temp=[x y datab(x,y)];
%         x3=[x3 ;temp];
%     end
% end
% T=clusterdata(x3,9);
% T=clusterdata(x3,'maxclust',5,'distance','seuclidean');
% for t=unique(T)'
%     if sum(T==t)<min_area
%         T(T==t)=0;
%     end
% end
% figure(1)
% imagesc(data);axis xy;
% figure(2)
% scatter3(x3(:,2),x3(:,1),x3(:,3),100,T,'filled');view(0,90);

