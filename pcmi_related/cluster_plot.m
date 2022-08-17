%%cluster plot
idx=3;
I_min=0.1;
data_plot=data.SL{idx};   %plot @ trial level,without integration 
% plot_vec=cell(size(data));
plot_vec=[];
for x=1:size(data_plot,1)
    for y=1:size(data_plot,2)
        if ~isempty(data_plot{x,y})
            [cent,c_std]=cluster_find(data_plot{x,y},50,0.98,I_min,95,1);
            caxis([0 1]);colorbar;
            title([num2str(x) '-' num2str(y)]);
%             temp=zeros(size(cent,1),4);
%             for len=1:size(cent,1)
%                 temp(len,:)=[x y cent(len,:)];
                pause();
%             end
%             plot_vec{x,y}=temp;
            for len=1:size(cent,1)
                plot_vec=[plot_vec; x y cent(len,:).*5];
%                 pause();
            end
        end
    end
end

% scatter(plot_vec(:,1),plot_vec(:,2),30,plot_vec(:,3),'filled');

data2=Iyxs{idx};   %plot @ trial level,without integration 
% plot_vec2=cell(size(data));
plot_vec2=[];
for x=1:size(data2,1)
    for y=1:size(data2,2)
        if ~isempty(data2{x,y})
            [cent,c_std]=cluster_find(data2{x,y},15,0.98,I_min,95,1);
%             temp=zeros(size(cent,1),4);
%             for len=1:size(cent,1)
%                 temp(len,:)=[x y cent(len,:)];
% %                 pause();
%             end
%             plot_vec2{x,y}=temp;
            for len=1:size(cent,1)
                plot_vec2=[plot_vec2; x y cent(len,:).*5];
%                 pause();
            end
        end
    end
end
scatter3(plot_vec(:,1),plot_vec(:,2),plot_vec(:,4),plot_vec(:,3),'ob','filled');
xlabel('channels');ylabel('starttimes');zlabel('delays');
hold on
scatter3(plot_vec2(:,1),plot_vec2(:,2),plot_vec2(:,4),plot_vec2(:,3),'or','filled');
xlabel('channels');ylabel('starttimes');zlabel('delays');
hold off;
information_flow