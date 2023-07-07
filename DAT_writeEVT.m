function DAT_writeEVT(filename,time_cell,descriptions)
time_cell = cellfun(@(x) x(1:length(x)),time_cell,'uni',0);
des_array = cellfun(@(x,y) repmat({y},length(x),1),time_cell,descriptions,'uni',0);
des_array = cat(1,des_array{:});
t_array = cat(2,time_cell{:});
[t_array,ix] = sort(t_array);
des_array = des_array(ix);
events.time = t_array;
events.description = des_array;
SaveEvents(filename,events,'overwrite','on');