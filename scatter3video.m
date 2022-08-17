%2012-5-14 created by Zifang Zhao
% function scatter3video()
[filename pathname]=uigetfile('*.fig','Select scatter3 figure');

fg=open([pathname filename]);    %scatter3
legend off;
h=get(gca,'Children');
dataX=get(h,'Xdata');
dataY=get(h,'Ydata');
dataZ=get(h,'Zdata');
dataC=get(h,'Cdata');
Zsize=get(h,'Sizedata');

[az el]=view;
disp('Creating video clip...')
video_name=[pathname filename(1:end-4)];
aviobj = avifile([video_name '.avi'],'compression','None','fps',10);
try
    % set(gcf, 'Renderer', 'OPENGL')
    for cam_angle=1:360;
        set(h,'Xdata',dataX{1});
        set(h,'Ydata',dataY{1});
        set(h,'Zdata',dataZ{1});
        set(h,'Cdata',dataC{1});
        view([az+cam_angle,el]);
        F=getframe(fg);
        set(h,'Xdata',dataX{2});
        set(h,'Ydata',dataY{2});
        set(h,'Zdata',dataZ{2});
        set(h,'Cdata',dataC{2});
        F2=getframe(fg);
        F_merge=F;
%         F_diff=imabsdiff(F.cdata,F2.cdata);
        
        F_merge.cdata=imadjust(imfuse(F.cdata,F2.cdata,'blend'),[0.3 0.3 0.3;1 1 1 ],[]);
%         imshow(F_merge.cdata);
%         cap=figure();
%         imshow(frame2im(F));hold on;
%         imshow(frame2im(F2));
%         alpha(0.8);
%         hold off;
%         F_merge=getframe(cap);
        aviobj=addframe(aviobj,F_merge);
    end
    
end
aviobj=close(aviobj);
close all;