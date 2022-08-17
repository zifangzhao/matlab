%% return data cursor 
function cursors=data_cursor(fig)
if nargin<1
    fig=gcf;
end
dcm=datacursormode(fig);
datacursormode(fig,'on');
cursors=getCursorInfo(dcm);