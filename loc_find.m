function [locs]=loc_find(data,min_I,min_percent)
% revised by zifang zhao @ 2013-2-23 ������һά�������������
% revised by zifang zhao @ 2012-9-27 ���Ϸ���������󣬺ϳ�ͬһ�����
% created by zifang zhao @ 2012-9-7 ����ʱ�ṹ����ȡ���ڹ涨ֵ�ĵ��λ�úʹ�С

datab=data>=prctile(reshape(data,1,[]),min_percent)&data>min_I;
[locs_x locs_y]=find(datab);
loc_val=data(datab);
if sum(size(data))-1==length(data)
    locs=[locs_y' locs_x' loc_val'];
else
    locs=[locs_y locs_x loc_val];
end