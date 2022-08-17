%information direction plotting 3D

temp=[plot_vec2(:,2),plot_vec2(:,1),plot_vec2(:,3),plot_vec2(:,4)];
plot_vec3=[plot_vec;temp];

%% information selecting
region={[1:8],[9:16],[17:24],[25,32]};
region_name={'Cg1','OFC','S1','PAG'};
for rgn1=1:length(region)
    channel_plot_in=plot_vec3(ismember(plot_vec3(:,2),region{rgn1}),:,:,:);
    channel_plot_out=plot_vec3(ismember(plot_vec3(:,1),region{rgn1}),:,:,:);
    figure(2)
    subplot(ceil(length(region)/2),ceil(length(region)/2),rgn1)
    scatter3(channel_plot_in(:,1),channel_plot_in(:,3),channel_plot_in(:,4),'b');hold on;
    scatter3(channel_plot_out(:,2),channel_plot_out(:,3),channel_plot_out(:,4),'r*');hold off;
    title(region_name{rgn1});
    xlim([0 size(data,1)]);
    ylim([0 size(data{1,2},1)*5]);
    zlim([0 size(data{1,2},2)*5]);
    xlabel('channels');ylabel('starttimes');zlabel('delays');
    if isempty(channel_plot_in)
        legend('Out');
    else
        legend('In','Out');
    end
end
xtick=[];
rgn_line={'b' 'r' 'k' 'g' 'c' 'p'};
region_plot_out=cell(length(region));
for rgn1=1:length(region)
    for rgn2=1:length(region)
        %     channel_plot_in=plot_vec3(ismember(plot_vec3(:,2),region{rgn}),:,:,:);
        region_plot_out{rgn1,rgn2}=plot_vec3(ismember(plot_vec3(:,1),region{rgn1})&ismember(plot_vec3(:,2),region{rgn2}),:,:,:);
        figure(3)
        %     subplot(ceil(length(region)/2),ceil(length(region)/2),rgn)
        scatter3(repmat(4*(rgn1-1)+rgn2,[size(region_plot_out{rgn1,rgn2},1) 1]),region_plot_out{rgn1,rgn2}(:,3),region_plot_out{rgn1,rgn2}(:,4),rgn_line{rgn2},'filled');hold on;
        xtick=[xtick {[region_name{rgn1} '->' region_name{rgn2}]}];
%         title(region_name{rgn1});
        %     xlim([0 size(data,1)]);
        ylim([0 size(data{1,2},1)*5]);
        zlim([0 size(data{1,2},2)*5]);
        xlabel('channels');ylabel('starttimes');zlabel('delays');
    end
end
hold off;
set(gca,'XTick',1:length(region)^2)
set(gca,'XTickLabel',xtick)
rgn_line={'b' 'r' 'k' 'g' 'c' 'p'};
for rgn1=1:length(region)
    for rgn2=1:length(region)
        %     channel_plot_in=plot_vec3(ismember(plot_vec3(:,2),region{rgn}),:,:,:);
        channel_plot_out=plot_vec3(ismember(plot_vec3(:,1),region{rgn1})&ismember(plot_vec3(:,2),region{rgn2}),:,:,:);
        figure(5)
        %     subplot(ceil(length(region)/2),ceil(length(region)/2),rgn)
        scatter(repmat(4*(rgn1-1)+rgn2,[size(channel_plot_out,1) 1]),channel_plot_out(:,3)+channel_plot_out(:,4),rgn_line{rgn2},'filled');hold on;
        xtick=[xtick {[region_name{rgn1} '->' region_name{rgn2}]}];
%         title(region_name{rgn1});
        %     xlim([0 size(data,1)]);
%         ylim([0 size(data{1,2},1)*5]);
%         zlim([0 size(data{1,2},2)*5]);
        xlabel('channels');ylabel('starttimes+delay');
    end
end
hold off;
set(gca,'XTick',1:length(region)^2)
set(gca,'XTickLabel',xtick)