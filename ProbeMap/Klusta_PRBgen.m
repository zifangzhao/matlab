function Klusta_PRBgen(fname,ch_conn,ch_loc)
% function for changing XML file channel order/group and color
% input:
 %fname: filename for the generated prb file
 %ch_conn: connection map for probe, each shank is a cell, Nx2 matrix in
 %the cell
 %ch_loc: channel location Nx3 matrix, [channel_idx,X,Y], also organized
 %in cell
% 20200403 created zifang zhao

if(~iscell(ch_conn))
    disp('Please input connection as cell array, with each shank as a cell')
end
txt=['channel_groups = {' newline];

for idx=1:length(ch_conn)
    listch=ch_conn{idx};
    N=size(listch,1);
    ch_map=ch_loc{idx};
    str_group=sprintf('\t %d : \r \t \t { \r ',idx-1);
    str_channels=sprintf('\t \t \t ''channels'':[');
%     str_channel_all=['list(range(',num2str(size(ch_map,1)) ')'];
    str_channel_all=arrayfun(@(x) [num2str(x) ','],sort(ch_map(:,1)),'uni',0);
    str_channel_all=[str_channel_all{:}];
    str_channel_end=sprintf('],\r');

    str_conn=sprintf('\t \t \t ''graph'':[ \r');
   
    t_conn=arrayfun(@(x) sprintf('\t \t \t \t (%d,%d), \r',listch(x,1),listch(x,2)),1:N,'uni',0);
    str_conn_end=sprintf(' \t \t \t ], \r');
    
    
    Nch=size(ch_map,1);
    str_map=sprintf(' \t \t \t ''geometry'':{ \r');
    t_map=arrayfun(@(x) sprintf('\t \t \t \t %d:(%d,%d), \r',ch_map(x,1),ch_map(x,2),ch_map(x,3)),1:Nch,'uni',0);
    t_map_end=sprintf(' \t \t \t } \r \t \t },\r');
    txt=[txt str_group str_channels str_channel_all str_channel_end str_conn t_conn{:} str_conn_end str_map t_map{:} t_map_end];
end
t_end=sprintf(' }');
txt=[txt t_end];
f=fopen(fname,'w');
fwrite(f,txt);
fclose(f);