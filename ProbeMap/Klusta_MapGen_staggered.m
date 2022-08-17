%% connection/map generation for staggered probe
function map=Klusta_MapGen_staggered(ch)
% %% ch should be a cell array, each cell is one shank
% map.connection=cell(length(ch),1);
% map.map=cell(length(ch),1);
% for idx=1:length(ch)
%     ch_shank=ch{idx};
%     Nch=length(ch_shank);
%     map.connection{idx}=[ch_shank(1:end-1) ch_shank(2:end)];
%     map.map{idx}=[ch_shank  zeros(Nch,1) (1:Nch)'*10];
% end
%
% %for A32 poly

rows={[1:10],[11 22 12 21 13 20 14 19 15 18 16 17],[32:-1:23]};
rows=cellfun(@(x) x-1,rows,'uni',0); %change to base 0
%add linear connection first
conn=[];
for r=1:length(rows)
    for idx=1:length(rows{r})-1
        conn=[conn; rows{r}(idx:idx+1);];
    end
end
% add neighbor connection
c=[ rows{1}; rows{2}(1:length(rows{1}))]';
conn=[conn;c];
c=[ rows{1}; rows{2}(2:1+length(rows{1}))]';
conn=[conn;c];
c=[ rows{3}; rows{2}(1:length(rows{1}))]';
conn=[conn;c];
c=[ rows{3}; rows{2}(2:1+length(rows{1}))]';
conn=[conn;c];

map.connection{1}=conn;
N=cellfun(@length,rows);
l1= [rows{1}' ones(N(1),1)*-10 ((1:N(1))'*10+5)];
l2=[rows{2}' ones(N(2),1)*0 ((1:N(2))'*10)];
l3=[rows{3}' ones(N(3),1)*10 ((1:N(3))'*10+5)];
map.map{1}=[l1 ;l2; l3];