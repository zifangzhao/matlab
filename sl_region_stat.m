%%统计SL数据
function [t_test jobhandle]=sl_region_stat(yA,yB,channelmask,pathname,filename,sch)
% 2012-4-19 revised by Zifang Zhao 将t_test变为结构，其中增加t值、标准差
% 2012-4-16 revised by Zifang Zhao 修正test输出为p值
% 2012-4-15 created by Zifang Zhao
jobhandle=[];
if nargin<3
    channelmask=ones(size(yA));
end

%找到需要整合的通道
loc_map_A=ones(size(yA))-cellfun(@isempty,yA);
loc_map_B=ones(size(yB))-cellfun(@isempty,yB);
non_zeros_locs_A=find(loc_map_A.*channelmask);
non_zeros_locs_B=find(loc_map_B.*channelmask);
if(isempty(non_zeros_locs_A)||isempty(non_zeros_locs_B))
    t_test.p=nan;
    t_test.sd=nan;
    t_test.t=nan;
else

    yA_selected=yA(non_zeros_locs_A);
    yB_selected=yB(non_zeros_locs_B);
    yA_selected_mat=[yA_selected{:}];
    yB_selected_mat=[yB_selected{:}];
    [~,t_test.p,~,temp]=ttest2(yA_selected_mat,yB_selected_mat);
    t_test.t=temp.tstat;
    t_test.sd=temp.sd;
end
%%构建统计量
[idx1,idx2]=find(channelmask);
idx1=unique(idx1);
idx2=unique(idx2);
meanA=cellfun(@cal_mean,yA(idx1,idx2),'UniformOutput',0);
meanB=cellfun(@cal_mean,yB(idx1,idx2),'UniformOutput',0);
if nargin>5
    jobhandle=batch(sch,@divplot,0,{meanA,meanB,pathname,filename});
else
    divplot(meanA,meanB,pathname,filename);
end
end

function divplot(yA,yB,pathname,filename)
t=cellfun(@BdivA,yA,yB);
close all;
h=figure(2);
imagesc(t);
colorbar
caxis([0 2]);
titlename=strrep(filename,'_','\_');
title(titlename);
% %% drawing rectangles
% for xx=1:size(t,1)
%     for yy=1:size(t,2)
%         if t_test(xx,yy)<alp
%             px=xx-0.5;
%             py=yy-0.5;
%             w=1;
%             h=1;
%             hold on;
%             rectangle('Position',[px,py,w,h],'Curvature',[0.8,0.4],'LineWidth',2,'LineStyle','--','EdgeColor','r')
%         end
%     end
% end
%% ploting figures
set(h,'Position',[100,100,900,700], 'color','w')
saveas(h,[pathname filename],'fig')
print(h,'-djpeg90','-r600',[pathname filename]);
end
function b_a=BdivA(A,B)
b_a=B/A;
if b_a==Inf
    b_a=0;
end
end
function x_mean=cal_mean(X)
if isempty(X)
    x_mean=0;
else
    x_mean=mean(X);
end
end