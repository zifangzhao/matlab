function [locs]=loc_find(data,min_I,min_percent)
% revised by zifang zhao @ 2013-2-23 修正了一维矩阵的整合问题
% revised by zifang zhao @ 2012-9-27 整合幅度至坐标后，合成同一个输出
% created by zifang zhao @ 2012-9-7 从延时结构中提取大于规定值的点的位置和大小

datab=data>=prctile(reshape(data,1,[]),min_percent)&data>min_I;
[locs_x locs_y]=find(datab);
loc_val=data(datab);
if sum(size(data))-1==length(data)
    locs=[locs_y' locs_x' loc_val'];
else
    locs=[locs_y locs_x loc_val];
end