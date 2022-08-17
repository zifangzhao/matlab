%2012-5-10 created by Zifang Zhao
function scatter2video()
[filename pathname]=uigetfile('*.fig','Select scatter figure');
fg=open([pathname filename]);    %scatter2
h=get(gca,'Children');
dataX=get(h,'Xdata');
dataY=get(h,'Ydata');
dataZ=get(h,'Zdata');
dataC=get(h,'Cdata');
Zsize=get(h,'Sizedata');
f_clim=caxis;
f_xlim=[min(dataX) max(dataX)];
f_ylim=[min(dataY) max(dataY)];
cmap=colormap;
% xlabel('Ixy');
% ylabel('Iyx');
% f_title=get(h,'title');
disp('Creating video clip...')
video_name=[pathname filename(1:end-4)];

aviobj = avifile([video_name '.avi'],'compression','None','fps',10);
try
% set(gcf, 'Renderer', 'OPENGL')
for idx=1:length(dataX)
    scatter(dataX(1:idx),dataY(1:idx),Zsize,dataC(1:idx),'o','filled');
    xlim(f_xlim);
    ylim(f_ylim);
    xlabel('Ixy');
    ylabel('Iyx');
    colormap(cmap)
    
    caxis(f_clim);colorbar
    F=getframe(fg);
    aviobj=addframe(aviobj,F);
end
% for idx=1:length(dataX)
%     set(h,'Xdata',dataX(1:idx))
%     set(h,'Ydata',dataY(1:idx))
%     if ~isempty(dataZ);
%         set(h,'Zdata',dataZ(1:idx))
%     end
%     if length(Zsize)>1
%         set(h,'Sizedata',Zsize(1:idx))
%     end
%     if ~isempty(dataC)
%         set(h,'Cdata',dataC(1:idx));
% %         caxis(f_clim);
%     end
%     drawnow update;
% %     xlim(f_xlim);
% %     ylim(f_ylim);
%     colormap(cmap)
%     caxis(f_clim);
%     
%     F=getframe(fg);
%     aviobj=addframe(aviobj,F);
% end
end
aviobj=close(aviobj);
close all;