function map = DAT_LoadElectrodeMap(file)
if nargin<1
    file = "ElectrodeMap.xlsx";
end

% file = "ElectrodeMap.xlsx";
map=[];
map_names = sheetnames(file);
for idx = 1:length(map_names)
    data = readmatrix(file,"Sheet",map_names(idx));
    data = arrayfun(@(x) data(~isnan(data(:,x)),x),1:size(data,2),'UniformOutput',false);
    map=setfield(map,map_names(idx),data);
end
 
