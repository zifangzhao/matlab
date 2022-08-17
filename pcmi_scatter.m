function jobhandle=pcmi_scatter(xA,yA,zA,xB,yB,zB,channel_mask,LA,LB,pathname,filename,sch)
%input num                       1  2  3  4  5  6            7  8  9       10       11  12
% 2012-4-24 revised by Zifang Zhao 将scatter2左图加入label
% 2012-4-22 revised by zifang zhao 修正scatter2左图无colorbar问题，将其变为两幅图
% 2012-4-21 revised by zifang zhao 将scatter变为subplot形式
% 2012-4-17 revised by Zifang Zhao 将scatter3 A,B换了颜色
% 2012-4-16 created by Zifang Zhao
% 用来创建Ixys,Iyxs,delay之间的三维散点图
%% 初始化
jobhandle=[];
%% 在全部通道中，根据channel_mask找出需要计算的channels
loc_map_A=ones(size(yA))-cellfun(@isempty,yA);
loc_map_B=ones(size(yB))-cellfun(@isempty,yB);
if(nargin<7)
    non_zeros_locs_A=find(loc_map_A);
    non_zeros_locs_B=find(loc_map_B);
else
    non_zeros_locs_A=find(loc_map_A.*channel_mask);
    non_zeros_locs_B=find(loc_map_B.*channel_mask);
end
if nargin<=9
    LegendA='A';
    LegendB='B';
end
if(isempty(non_zeros_locs_A)||isempty(non_zeros_locs_B))
else
    xA_selected=xA(non_zeros_locs_A);yA_selected=yA(non_zeros_locs_A);zA_selected=zA(non_zeros_locs_A);
    yB_selected=yB(non_zeros_locs_B);xB_selected=xB(non_zeros_locs_B);zB_selected=zB(non_zeros_locs_B);
    
    xA_selected_mat=[xA_selected{:}];yA_selected_mat=[yA_selected{:}];zA_selected_mat=[zA_selected{:}];
    xB_selected_mat=[xB_selected{:}];yB_selected_mat=[yB_selected{:}];zB_selected_mat=[zB_selected{:}];
    if nargin>=12
        jobhandle=batch(sch,@scatter_plot,0,{xA_selected_mat,yA_selected_mat,zA_selected_mat,xB_selected_mat,yB_selected_mat,zB_selected_mat,LA,LB,pathname,filename});
    else
        scatter_plot(xA_selected_mat,yA_selected_mat,zA_selected_mat,xB_selected_mat,yB_selected_mat,zB_selected_mat,LA,LB,pathname,filename);
    end
end

end

function scatter_plot(xA,yA,zA,xB,yB,zB,LA,LB,pathname,filename)
close all
h=figure();
xM=max([xA xB]);
yM=max([yA yB]);
LA=strrep(LA,'_','\_');
LB=strrep(LB,'_','\_');
% subplot(1,2,1)
scatter(xA,yA,15,zA,'o');
xlim([0 xM]);
ylim([0 yM]);
legend(LA);
titlename=strrep(filename,'_','\_');
title(titlename);
colorbar;
xlabel('Ixy');ylabel('Iyx');zlabel('delay');
saveas(h,[pathname filename '_scatter2_1'],'fig')
print(h,'-djpeg90','-r600',[pathname filename '_scatter2_1']);

% subplot(1,2,2)
scatter(xB,yB,35,zB,'+');
xlim([0 xM]);
ylim([0 yM]);
xlabel('Ixy');ylabel('Iyx');zlabel('delay');
titlename=strrep(filename,'_','\_');
title(titlename);
legend(LB);
colorbar;
set (h,'Position',[100,100,900,700], 'color','w')
saveas(h,[pathname filename '_scatter2_2'],'fig')
print(h,'-djpeg90','-r600',[pathname filename '_scatter2_2']);
close(h);
close all
h=figure();
scatter3(xA,yA,zA,5,'or','filled');
xlim([0 xM]);
ylim([0 yM]);
hold on;
scatter3(xB,yB,zB,5,'ob','filled');
xlim([0 xM]);
ylim([0 yM]);
xlabel('Ixy');ylabel('Iyx');zlabel('delay');
title(titlename);
legend(LA,LB);
set (h,'Position',[100,100,900,700], 'color','w')
saveas(h,[pathname filename '_scatter3'],'fig')
print(h,'-djpeg90','-r600',[pathname filename '_scatter3']);
close(h);
end