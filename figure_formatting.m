%%Formatting current plot
function figure_formatting(h,width,height,axis_arr,fig_cmd,cbar,clim)
if nargin<1
    h = gcf;
end
if nargin<5
    width=600;
    height=600;
    axis_arr=0;
    fig_cmd=[];
    cbar=0;
    clim=[];
end
set(h,'renderer','painter')


font = 'Times New Roman';
line_width = 2;
label_font_size = 24;
title_font_size = 36;
width_initial = 1200;
height_initial = 800;
font_only=0;
set(h,'Windowstyle','normal');
p=get(h,'Position');
p(3)=width_initial;
p(4)=height_initial;
set(h,'Position',p); % automate axis labels in the begining
% set(gcf,'Position',p);



all_cld=get(h,'Children');
all_axes=findall(all_cld,'type','axes');
arrayfun(@(x) set_axes(x,axis_arr,font_only,fig_cmd,cbar,clim,font,label_font_size),all_axes);  %ÐÞÕýËùÓÐ×ø±êÖá
arrayfun(@(x) set(x,'linewidth',line_width),all_axes);
all_cld=get(h,'Children');
cbar_axes=findall(all_cld,'tag','Colorbar');                                   %ÐÞÕýcolorbar×ø±êÖá
if(~isempty(cbar_axes))
    arrayfun(@(x) set_axes(x,axis_arr,1,[],0,clim,font,label_font_size),cbar_axes);
end

all_lines = findall(all_cld,'type','line');
arrayfun(@(x) set(x,'linewidth',line_width),all_lines);

all_title=findall(h,'type','Text');
arrayfun(@(x) set(x,'Fontname',font,'Fontsize',title_font_size),all_title);

h_all=unique(findall(findobj,'type','figure'));
idx=h_all==h;
arrayfun(@close,h_all(~idx));

set(h,'Windowstyle','normal');
p=get(h,'Position');
p(3)=width;
p(4)=height;
set(h,'Position',p);

function set_axes(h,axis_arr,font_only,fig_cmd,cbar,clim,font,font_size)
set(h,'Fontname',font,'Fontsize',font_size,'Gridcolor',[0,0,0],'MinorGridcolor',[0,0,0]);
axes(h);
set(h,'XtickMode','manual');
set(h,'YtickMode','manual');
all_cld=get(h,'Children');

all_ticklabel = findall(h,'type','text');
arrayfun(@(x) set(x,'fontsize',1.5*font_size,'color',[0,0,0]),all_ticklabel);

if ~font_only
%     xt=get(h,'Xtick');
%     yt=get(h,'Ytick');
%     if length(xt)>length(yt)
%         set(h,'Xtick',yt);
%     else
%         set(h,'Ytick',xt);
%     end
    axes_loc=get(h,'Position');
    if axis_arr==1
        annotation('arrow',[axes_loc(1) axes_loc(1)],[axes_loc(2) 1.03*(axes_loc(2)+axes_loc(4))],'Headstyle','vback3','lineWidth',2,'Headlength',15,'HeadWidth',12)
        annotation('arrow',[axes_loc(1) 1.03*(axes_loc(1)+axes_loc(3))],[axes_loc(2) axes_loc(2)],'Headstyle','vback3','lineWidth',2,'Headlength',15,'HeadWidth',12)
    end
    if ~isempty(fig_cmd)
        eval(fig_cmd);
    end
    if cbar
        colorbar;
        if ~isempty(clim)
            caxis(clim)
        end
    end
end
% annotation('arrow',x,y)