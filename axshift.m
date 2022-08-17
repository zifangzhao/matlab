
% function axshift
% axshift() -funtion to manually resize and rescale subplots/axis within a figure
% 
% rationale:
% a] resize of subplots/axes manully in a wysiwyg fashion
% b] multiple subplots with different sizes,
% c] overlapping supplots (transparent or not), graphical overlay
% d] create a layout with subplot locations for other figures/data
%
% usage:
% 1] plot figure with subplots
% 2] type 'axshift'
% 3] an icon appears in the toolbar
% 4] if this icon is selected (colored)
%     -selected axes/subplots of the figure can be moved
% 5] via contextmenu (right mouse click in the figure,but not within a subplot)
%     the following functions are available
%    - BG-original: backgroundcolor of each subplot set to orig. color
%    - BG-none:     transparent background
%    - position-original: original positions of the subplots
%    - position-last one: previous positions
%    - positions to workspace: parse new positions of all subplots to the workspace. This might
%      be usefull for creating template layout for other data, The order of positions equals the order of the
%      originally plotted subplots
%
%     - resize all: resize all subplots by means of the mouse wheel (backwards: larger; forward: smaller)
%       note: a size of 100% refers to the size when the 'resize all'-function is executed.
%     - resize indiv: if selected an axes, drag the corner-and midpoints of the subplot to resize the axes
%     - shift axes: selected axes/subplots of the figure can be moved
%
%  6] additionally there are 3 shortkeys for fast switching between
%    shifting and rescaling functions
%     (press key if the figure is active)
%     [a]: activate the 'resize all' function
%     [d]: activate the 'resize indiv' function
%     [s]: activate the 'shift axes' function
%
%example: you can use this example to play around
% figure('color',[1 1 1]);
% for i=1:9;
%     subplot(4,3,i)
%     plot(1:40, rand(40,1),'color',[rand(1) rand(1) rand(1)],'linewidth',2);
%     title(num2str([i]),'fontweight','bold');
% end
% subplot(4,3,i+1);image,axis tight;colorbar;
% subplot(4,3,i+2);image,axis tight;colorbar
% subplot(4,3,i+3);image,axis tight;
% axshift;
%
% ----------------------------------------------------------------------
% Author: S.P.Koch, BNIC 2009 [paulekoch@ymail.com]
% ----------------------------------------------------------------------


%============================================
%
%============================================


function axshift


% ------------Ui-push---------------
%### icons
c(:,:,1)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1           1         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6         0.6         0.6           1         0.6           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1         0.6         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1           1           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1           1           1           1         0.6           1           1           1         0.6           1; 0.99608         0.6           1           1         0.6         0.6           1         0.6           1           1         0.6         0.6           1           1         0.6           1; 0.99608         0.6           1         0.6           1         0.6           1         0.6         0.6           1         0.6           1         0.6           1         0.6           1; 0.99608         0.6         0.6           1           1         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1         0.6         0.6           1         0.6           1           1           1         0.6           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c(:,:,2)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1           1         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6         0.6         0.6           1         0.6           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1         0.6         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1           1           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1           1           1           1         0.6           1           1           1         0.6           1; 0.99608         0.6           1           1         0.6         0.6           1         0.6           1           1         0.6         0.6           1           1         0.6           1; 0.99608         0.6           1         0.6           1         0.6           1         0.6         0.6           1         0.6           1         0.6           1         0.6           1; 0.99608         0.6         0.6           1           1         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1         0.6         0.6           1         0.6           1           1           1         0.6           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c(:,:,3)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1           1         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6         0.6         0.6           1         0.6           1         0.6           1           1           1           1; 0.99608         0.6           1           1           1         0.6           1         0.6           1           1         0.6         0.6           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6         0.6         0.6         0.6         0.6           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1           1           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1           1           1           1         0.6           1           1           1         0.6           1; 0.99608         0.6           1           1         0.6         0.6           1         0.6           1           1         0.6         0.6           1           1         0.6           1; 0.99608         0.6           1         0.6           1         0.6           1         0.6         0.6           1         0.6           1         0.6           1         0.6           1; 0.99608         0.6         0.6           1           1         0.6         0.6         0.6         0.6         0.6         0.6           1           1         0.6         0.6           1; 0.99608         0.6           1           1           1         0.6           1         0.6         0.6           1         0.6           1           1           1         0.6           1; 0.99608         0.6         0.6         0.6         0.6         0.6           1         0.6           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];

c2(:,:,1)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.4         0.4         0.4         0.4     0.41176           1         0.4         0.4         0.4         0.4         0.4           1           1           1           1; 0.99608         0.4           1           1           1     0.41176           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608         0.4     0.38824           0     0.38824     0.41176           1         0.4     0.80392           1           1         0.4           1           1           1           1; 0.99608           0           1           1           1     0.41176           1           0           1           0           1         0.4           1           1           1           1; 0.99608           0           1           1           1    0.023529           1           0           1           1           0           0           1           1           1           1; 0.99608           0           0           0           0    0.023529           1           0           0           0           0           0           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.4         0.4         0.4     0.41176     0.41176           1           1           1           1     0.42353     0.42353     0.42353     0.42353     0.42353           1; 0.99608         0.4           1           1           1     0.41176           1           1           1           1     0.42353           1           1           1     0.42353           1; 0.99608         0.4           1           1     0.62353     0.41176           1         0.8           1           1     0.42353           0           1           1     0.42353           1; 0.99608         0.4           1     0.38824           1     0.41176           1         0.8         0.8           1     0.18824           1           0           1     0.42353           1; 0.99608           0     0.38824           1           1     0.60784     0.57647     0.57647     0.57647     0.57647     0.18824           1           1           0     0.42353           1; 0.99608           0           1           1           1    0.078431           1         0.6         0.6           1     0.18824           1           1           1     0.18824           1; 0.99608           0           0           0    0.078431    0.078431           1         0.6           1           1     0.18824     0.18824     0.18824     0.18824     0.18824           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c2(:,:,2)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.4         0.4         0.4         0.4     0.39216           1         0.4         0.4         0.4         0.4         0.4           1           1           1           1; 0.99608         0.4           1           1           1     0.39216           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608         0.4     0.40392   0.0039216     0.40392     0.39216           1         0.4     0.80392           1           1         0.4           1           1           1           1; 0.99608   0.0039216           1           1           1     0.39216           1   0.0039216           1   0.0039216           1         0.4           1           1           1           1; 0.99608   0.0039216           1           1           1           0           1   0.0039216           1           1   0.0039216   0.0039216           1           1           1           1; 0.99608   0.0039216   0.0039216   0.0039216   0.0039216           0           1   0.0039216   0.0039216   0.0039216   0.0039216   0.0039216           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.4         0.4         0.4     0.39216     0.39216           1           1           1           1     0.79216     0.79216     0.79216     0.79216     0.79216           1; 0.99608         0.4           1           1           1     0.39216           1           1           1           1     0.79216           1           1           1     0.79216           1; 0.99608         0.4           1           1     0.58431     0.39216           1         0.4           1           1     0.79216     0.41176           1           1     0.79216           1; 0.99608         0.4           1     0.40392           1     0.39216           1         0.4         0.4           1         0.6           1     0.41176           1     0.79216           1; 0.99608   0.0039216     0.40392           1           1           0   0.0078431   0.0078431   0.0078431   0.0078431         0.6           1           1     0.41176     0.79216           1; 0.99608   0.0039216           1           1           1           0           1   0.0039216   0.0039216           1         0.6           1           1           1         0.6           1; 0.99608   0.0039216   0.0039216   0.0039216           0           0           1   0.0039216           1           1         0.6         0.6         0.6         0.6         0.6           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];
c2(:,:,3)=[0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1; 0.99608         0.4         0.4         0.4         0.4     0.40784           1         0.4         0.4         0.4         0.4         0.4           1           1           1           1; 0.99608         0.4           1           1           1     0.40784           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608         0.4     0.98824     0.99608     0.98824     0.40784           1         0.4           1           1           1         0.4           1           1           1           1; 0.99608           0           1           1           1     0.40784           1           0           1     0.99608           1         0.4           1           1           1           1; 0.99608           0           1           1           1           0           1           0           1           1     0.99608           0           1           1           1           1; 0.99608           0           0           0           0           0           1           0           0           0           0           0           1           1           1           1; 0.99608           1           1           1           1           1           1           1           1           1           1           1           1           1           1           1; 0.99608         0.4         0.4         0.4     0.40784     0.40784           1           1           1           1           0           0           0           0           0           1; 0.99608         0.4           1           1           1     0.40784           1           1           1           1           0           1           1           1           0           1; 0.99608         0.4           1           1           1     0.40784           1   0.0078431           1           1           0     0.99608           1           1           0           1; 0.99608         0.4           1     0.98824           1     0.40784           1   0.0078431   0.0078431           1    0.035294           1     0.99608           1           0           1; 0.99608           0     0.98824           1           1           0    0.019608    0.019608    0.019608    0.019608    0.035294           1           1     0.99608           0           1; 0.99608           0           1           1           1           0           1           0           0           1    0.035294           1           1           1    0.035294           1; 0.99608           0           0           0           0           0           1           0           1           1    0.035294    0.035294    0.035294    0.035294    0.035294           1; 0.99608     0.99608     0.99608     0.99608     0.99608           1           1           1           1           1     0.99608     0.99608     0.99608     0.99608     0.99608           1];

p=[];
p.c0=c;
p.c1=c2;

set(gcf,'toolbar','figure');
tb = findall(gcf,'Type','uitoolbar');
pm=[];
p.tgnow=0;
mycdat=p.c0;
% ----------------------
p.hp= uipushtool(tb(1),'TooltipString', 'axshift', ...
    'CData', [mycdat], 'clickedcallback', {@iconON, pm},...
    'userdata',p, 'tag', 'axshift');%,'offcallback',@limOFF);

%%%••••••••••••••••••••••••••••••••••••••••••••••
%   subfuns icon on/off
%%%••••••••••••••••••••••••••••••••••••••••••••••

function iconON(obj, event, pm)
p=get(obj,'userdata');



if p.tgnow==0
    x=[];
    x.old=get(gcf,'userdata');


    set(obj,'cdata',p.c1,'TooltipString','shift axes ON');  %shift axes ON
    set (gcf, 'WindowButtonDownFcn', {@gdown, x});
    set (gcf, 'WindowButtonUpFcn', {@gup, x});
    p.tgnow=1;


    x.units=get(gcf,'units');
    set(gcf,'unit','normalized');
    set(gcf,'userdata',x);

    x.ch=findobj(gcf,'type','axes');
    x.bgcol=get(x.ch,'color');
    x.posorig=get(x.ch,'position');
    x.posorig2=x.posorig;
    cmenu = uicontextmenu;
    set(gcf,'UIContextMenu', cmenu);
    set(x.ch,'UIContextMenu', cmenu);

    % Define the context menu items
    item1 = uimenu(cmenu, 'Label','BG-original', 'Callback', {@gcontext, 1});
    item2 = uimenu(cmenu, 'Label','BG-none',  'Callback', {@gcontext, 2});
    item3 = uimenu(cmenu, 'Label','position-original',  'Callback', {@gcontext, 3});
    item4 = uimenu(cmenu, 'Label','position-last one',  'Callback', {@gcontext, 4});
    item5 = uimenu(cmenu, 'Label','positions to workspace (axshiftnew)',  'Callback', {@gcontext, 5});
    item6 = uimenu(cmenu, 'Label','resize all (scroll) [a]',  'Callback', {@gcontext, 6});
    item7 = uimenu(cmenu, 'Label','resize indiv [d]',  'Callback', {@gcontext,7});
    item8 = uimenu(cmenu, 'Label','shift axes [s]',  'Callback', {@gcontext,8});

    set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
    x.wheel=100;
    x.shift=1;
    set(gcf,'userdata',x);
    set(gcf,'KeyReleaseFcn',@cb);



else
    set(obj,'cdata',p.c0,'TooltipString','shift axes OFF');%shift axes OFF
    set (gcf, 'WindowButtonDownFcn', []);
    set (gcf, 'WindowButtonUpFcn', []);
    p.tgnow=0;

    x= get(gcf,'userdata');
    set(gcf,'unit',x.units);
    set(gcf,'userdata',x.old);

    ch=findobj(gcf,'type','axes');
    axshiftnew=get(ch,'position');
    assignin('base','axshiftnew',axshiftnew);


end
set(obj,'userdata',p);

%%%••••••••••••••••••••••••••••••••••••••••••••••
% subfun
%%%••••••••••••••••••••••••••••••••••••••••••••••
%----------------------------------
%            keyboard                
%----------------------------------
function cb(obj,event)
switch event.Character
    case 's' ;gcontext(obj, event, 8)
    case 'd' ;gcontext(obj, event, 7)
    case 'a' ;gcontext(obj, event, 6)
end

%----------------------------------
%          rescale subplots               
%----------------------------------
function gresize(obj, event, mode)
co=  get(gcf,'CurrentPoint');
x= get(gcf,'userdata');
sel=gca;
set(gcf,'currentaxes',sel);
uistack(sel,'top');
% try
if ~isempty(sel)
     delete(findobj(gcf,'tag','resi'));
    delete(findobj(gcf,'tag','cords'));
    xl=get( (sel),'xlim');
    yl=get( (sel),'ylim');
    prx= [diff(xl)/20];
    pry= [diff(yl)/20];

    set(gcf,'currentaxes', (sel) );
    hold on;
    ms=7;
    x.v(1)=plot(xl(1)+prx,         yl(1)+pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',           'ButtonDownFcn',{@gresize2, 1});
    x.v(2)=plot(diff(xl)/2+xl(1),  yl(1)+pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi','ButtonDownFcn',{@gresize2, 2});
    x.v(3)=plot(xl(2)-prx,             yl(1)+pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',           'ButtonDownFcn',{@gresize2, 3});

    x.v(4)=plot(xl(2)-prx,  diff(yl)/2+yl(1),'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi', 'ButtonDownFcn',{@gresize2, 4});
    x.v(5)=plot(xl(2)-prx,   yl(2)-pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',            'ButtonDownFcn',{@gresize2, 5});


    x.v(6)=plot(diff(xl)/2+xl(1), yl(2)-pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi','ButtonDownFcn',{@gresize2, 6});

    x.v(7)=plot(xl(1)+prx,         yl(2)-pry,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi',             'ButtonDownFcn',{@gresize2, 7});
    x.v(8)=plot(xl(1)+prx,         diff(yl)/2+yl(1)  ,'sk','MarkerSize',ms,'MarkerFaceColor','k','Tag','resi','ButtonDownFcn',{@gresize2, 8});
else
    delete(findobj(gcf,'tag','resi'));
    try;     delete(x.ve); end
    try; x.ve=[];end

end
set(gcf,'userdata',x);
% end

function gresize2(obj, event, mode)
set (gcf, 'WindowButtonMotionFcn',[]);
set (gcf, 'WindowButtonMotionFcn',{@gresize3, mode});
set (gcf, 'WindowButtonUpFcn',{@gcontext, 7});

function gresize3(obj, event, mode)
po= get(gca,'position');  cp=get(gcf,'CurrentPoint');

if mode==2
    df=po(2)-cp(2);
    po(2)=cp(2); po(4)=po(4)+df;
elseif mode==6
    df=cp(2)- po(2);    po(4)= df;
elseif mode==8
    df=po(1)-cp(1);    po(1)=cp(1); po(3)=po(3)+df;
elseif mode==4
    df=cp(1)- po(1);
    po(3)= df;
elseif mode==3
    df=cp(1)- po(1); po(3)= df;
    df=po(2)-cp(2);
    po(2)=cp(2); po(4)=po(4)+df;
elseif mode==1
    df=po(1)-cp(1);
    po(1)=cp(1); po(3)=po(3)+df;
    df=po(2)-cp(2);
    po(2)=cp(2); po(4)=po(4)+df;
elseif mode==5
    df=cp(1)- po(1);     po(3)= df;
    df=cp(2)- po(2);    po(4)= df;
elseif mode==7
    df=po(1)-cp(1);    po(1)=cp(1); po(3)=po(3)+df;
    df=cp(2)- po(2);    po(4)= df;
end
if po(3)>0 & po(4)>0
    set(gca,'position',po);
end
pos=[get(gca,'xlim') get(gca,'ylim')];
delete(findobj(gcf,'tag','cords'));
text(pos(1),pos(3)- (diff(pos(3:4))/5), num2str([(round(po*1000))./1000 ]) ,'tag','cords','VerticalAlignment','top',...
    'backgroundcolor',[0 0 0],'color',[1 1 1] ,'fontweight','bold','fontsize',8);

%----------------------------------
%              resize all                     
%----------------------------------
function gwheel(obj, event, mode)
x= get(gcf,'userdata');
x.wheel=x.wheel+       event.VerticalScrollCount;
set(gcf,'userdata',x);

for i=1:size(x.posorig,1)
    dx=x.posorig2{i};
    dx(:,3:4)=dx(:,3:4)*x.wheel/100;
    dz=get(x.ch(i),'position');
    %      dz(:,3:4)=dz(:,3:4)*x.wheel/100;
    % set(x.ch(i),'position',[dz ] );
    set(x.ch(i),'position',[dz(1:2) dx(3:4)] );
end



%----------------------------------
%             indiv. resize                     
%----------------------------------


function gdown(obj, event, x)
x= get(gcf,'userdata');
x.ax=gca;
uistack(x.ax,'top');
x.posax=get(gca,'position');
x.pospoint=get(gcf,'CurrentPoint');
x.axhelp= axes('position',[x.posax(1:2)  1  1],'color','none','xtick',[],...
    'ytick',[],'ycolor',[.7 .7 .7],'xcolor',[.7 .7 .7]);
x.axhelp2=axes('position',[x.posax(1:2)  1  1],'color','none','xtick',[],...
    'ytick',[],'ycolor',[.7 .7 .7],'xcolor',[.7 .7 .7]);
x.ax_xcolor=get(x.ax,'xcolor');
x.ax_ycolor=get(x.ax,'ycolor');
x.ax_box=get(x.ax,'box');
set(x.ax,'xcolor',[1 0 0],'ycolor',[1 0 0],'box','on');
set(gcf,'userdata',x);
set (gcf, 'WindowButtonMotionFcn', {@gmot, x});
% end

function gmot(obj, event, x)
po=x.posax; %position axis xy
poi=x.pospoint;%first buttondown position in axes
poinow=get(gcf,'CurrentPoint');%curretn position in axis
dx=po(1:2)-poi(1:2);
po(1:2)=[poinow+dx];

poh=get(x.axhelp,'position');poh(1:2)=[po(1) 0];
set(x.axhelp,'position',poh,'xtick',[],'ytick',[]);
poh=get(x.axhelp2,'position');poh(1:2)=[0 po(2)];
set(x.axhelp2,'position',poh,'xtick',[],'ytick',[]);
set(x.ax,'position',po);
set(x.ax,'xcolor',[1 0 0],'ycolor',[1 0 0],'box','on');


function gup(obj, event, x)
x=get(gcf,'userdata');
set (gcf, 'WindowButtonMotionFcn', []);
set(x.ax,'xcolor',x.ax_xcolor);
set(x.ax,'ycolor',x.ax_ycolor);
set(x.ax,'box',x.ax_box);

delete(x.axhelp);
delete(x.axhelp2);


%----------------------------------
%           contextmenu                       
%----------------------------------
function gcontext(obj, event, mode)
x= get(gcf,'userdata');
if mode==1
    for i=1:size(x.bgcol)
        set(x.ch(i),'color',x.bgcol{i}) ;
    end
elseif mode==2
    set(x.ch,'color','none') ;
elseif mode==3
    x.posnow=get(x.ch,'position');
    for i=1:size(x.bgcol)
        set(x.ch(i),'position',x.posorig{i}) ;
    end
elseif mode==4
    try
        for i=1:size(x.bgcol)
            set(x.ch(i),'position',x.posnow{i}) ;
        end
    end
elseif mode==5
    axshiftnew=get(x.ch,'position');
    assignin('base','axshiftnew',axshiftnew);
    disp('parsed varaible ''axshiftnew'' to workspace');
elseif mode==6
    delete(findobj(gcf,'tag','resi'));
    set (gcf, 'WindowButtonDownFcn', []);
    set (gcf, 'WindowButtonUpFcn', []);
    set (gcf, 'WindowButtonMotionFcn', []);

    x.posorig2=get(x.ch,'position') ;
    set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
elseif mode==7
    set(gcf,'WindowScrollWheelFcn',[]);
    % set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
    set (gcf, 'WindowButtonDownFcn', []);
    set (gcf, 'WindowButtonUpFcn', []);

    set (gcf, 'WindowButtonMotionFcn', {@gresize, x});
elseif mode==8
    delete(findobj(gcf,'tag','resi'));
    delete(findobj(gcf,'tag','resi'));
    set (gcf, 'WindowButtonMotionFcn', []);
    set (gcf, 'WindowButtonDownFcn', {@gdown, x});
    set (gcf, 'WindowButtonUpFcn', {@gup, x});

end
set(gcf,'userdata',x);

%
%       tests                                      
%
% % % % % 
% % % % % if 0
% % % % %     fg;
% % % % %     for k=1:13
% % % % %         subplot(3,5,k);
% % % % %         hold on;
% % % % %         %         plot(f, (xr(:,k)),'color',[.5 .5 .5],'linewidth',2);
% % % % %         plot(t, (ss2(:,k)),'color',[0 0 0],'linewidth',1);
% % % % %         ylim([mx]);
% % % % %         for m=1:10; vline(ma(m),'color',[.6 .6 .6],'linestyle',':'); end
% % % % %         plot(t, (ss2(:,k)),'color',[0 0 0],'linewidth',1.3);
% % % % %         title(e.el{k},'fontweight','bold');
% % % % %         xlim([0 1]);    %
% % % % %         ylim([mx]);
% % % % %     end
% % % % %     axshift
% % % % %     % tag=[name '_ssvep_' zeit(1) ] ; saveas(gcf,tag);saveas(gcf,tag,'emf');
% % % % % 
% % % % % 
% % % % % end






