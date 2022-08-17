%% connection/map generation for linear probe
function map=Klusta_MapGen(ch)
%% ch should be a cell array, each cell is one shank
map.connection=cell(length(ch),1);
map.map=cell(length(ch),1);
for idx=1:length(ch)
    ch_shank=ch{idx};
    Nch=length(ch_shank);
    map.connection{idx}=[ch_shank(1:end-1) ch_shank(2:end)];
    map.map{idx}=[ch_shank  zeros(Nch,1) (1:Nch)'*10];
end

