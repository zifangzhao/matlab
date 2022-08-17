% draw region and judege points inside region
function [in]=data_draw_region(data,tags,color)
if nargin<2
    tags=zeros(size(data,1),1);
end

if nargin<3
    color='b';
end

fig=gscatter(data(:,1), data(:,2), tags);
hold on;
poly_x=[];
poly_y=[];
button=0;
while button~=3;
    [x,y,button]=ginput(1);
    if button~=3
        if ~isempty(poly_x)
            plot([poly_x(end) x],[poly_y(end) y],color)
        end
        poly_x=[poly_x x];
        poly_y=[poly_y y];
    else
        plot([poly_x(end) poly_x(1)],[poly_y(end) poly_y(1)],color)
    end
end
in=inpolygon(data(:,1),data(:,2),poly_x,poly_y);
% close(fig);