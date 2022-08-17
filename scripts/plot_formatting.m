%%Formatting current plot
function plot_formatting(width,height,font_only,axis_arr,fig_cmd,cbar,clim)
if nargin<5
    width=600;
    height=400;
    font_only=0;
    axis_arr=1;
    fig_cmd=[];
    cbar=1;
    clim=[];
end
[filename,pathname] = uigetfile('*.fig','Open matlab figure');


h=openfig([pathname '/' filename]);
set(h,'Windowstyle','normal');
p=get(h,'Position');
p(3)=width;
p(4)=height;
set(h,'Position',p);
% set(gcf,'Position',p);

if ~font_only
    xlabel('Start time / ms')
    ylabel('Delay / ms')
end
all_title=findall(h,'type','Text');
arrayfun(@(x) set(x,'Fontname','Arial','Fontsize',16),all_title);


all_cld=get(h,'Children');
all_axes=findall(all_cld,'type','axes');
arrayfun(@(x) set_axes(x,axis_arr,font_only,fig_cmd,cbar,clim),all_axes);  %修正所有坐标轴
all_cld=get(h,'Children');
cbar_axes=findall(all_cld,'tag','Colorbar');                                   %修正colorbar坐标轴
arrayfun(@(x) set_axes(x,axis_arr,1,[],0,clim),cbar_axes);



h_all=unique(findall(findobj,'type','figure'));
idx=h_all==h;
arrayfun(@close,h_all(~idx));



function set_axes(h,axis_arr,font_only,fig_cmd,cbar,clim)
set(h,'Fontname','Arial','Fontsize',16);
axes(h);
if ~font_only
    xt=get(h,'Xtick');
    yt=get(h,'Ytick');
    if length(xt)>length(yt)
        set(h,'Xtick',yt);
    else
        set(h,'Ytick',xt);
    end
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