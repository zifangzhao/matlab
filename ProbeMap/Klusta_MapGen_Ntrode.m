%% connection/map generation for linear probe
function map=Klusta_MapGen_Ntrode(ch)
%% ch should be a cell array, each cell is one tetrode: {[0 1 2 3] [4 5 6 7] }
map.connection=cell(length(ch),1);
map.map=cell(length(ch),1);
for idx=1:length(ch)
    ch_shank=ch{idx};
    if(size(ch_shank,2)~=1)
        ch_shank=ch_shank'
    end
    Nch=length(ch_shank);
    map.connection{idx}=nchoosek(ch_shank,2);
    map.map{idx}=[ch_shank  idx*ones(Nch,1) (1:Nch)'*10];
end

