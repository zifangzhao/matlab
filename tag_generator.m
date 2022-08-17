%% File tags generator (cell form output)
function tags=tag_generator(str,sep)
%str is the string need to be seperated
%sep is the seperator string
loc_end=strfind(str,'.');
if ~isempty(loc_end)
    str=str(1:loc_end-1);
end
locs=strfind(str,sep);
locs=[0 locs length(str)+1];
tags=cell(1,length(locs)-1);
for idx=1:length(locs)-1
    tags{idx}=str(locs(idx)+1:locs(idx+1)-1);
end
