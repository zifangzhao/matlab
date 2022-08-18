%% Get Cluster infomation from Kwik format HDF5
function unit_all=PHY_readClusters(filename)
if(nargin<1 || isempty(filename))
    [f,p]=uigetfile('*.kwik');
    filename=[p,f];
end

fileinfo=hdf5info(filename);
grp_count=length(fileinfo.GroupHierarchy.Groups(2).Groups);
disp(['Opening kwik file, found ' num2str(grp_count) ' channel groups']);

unit_all=cell(grp_count,1);
for gidx=1:grp_count
    time=double(hdf5read(filename, ['/channel_groups/' num2str(gidx-1) '/spikes/time_samples']))+1;
    clu=hdf5read(filename, ['/channel_groups/' num2str(gidx-1) '/spikes/clusters/main']);
    clu_name={fileinfo.GroupHierarchy.Groups(2).Groups(1).Groups(3).Groups(1).Groups.Name};
    clu_id=cellfun(@(x) regexpi(x,'(?<=/channel_groups/)\d+(?<!/clusters/main/)','match'),clu_name,'uni',0);
    clu_id=cellfun(@(x) str2num(x{1}),clu_id);
%     clu_id=cellfun(@(x) str2num(strrep(x,['/channel_groups/' num2str(gidx-1) '/clusters/main/'],[])),clu_name);
    clu_label=arrayfun(@(x) x.Attributes.Value,fileinfo.GroupHierarchy.Groups(2).Groups(gidx).Groups(3).Groups(1).Groups(:));
    
    % Filter clu by label 0=noise;1=MUA;2=Good;3=Unsorted
    clu_id_valid=clu_id(ismember(clu_label,[0 1 2 3]));  %Change here for selecting groups
    clu=clu(ismember(clu,clu_id_valid)); %keep only valid clusters
    
    spike.time=time;
    spike.clu=clu;               %unit group
    
    %%
    %Input: filename of the .kwik file
    %Output: unit (cell structure)
    % each cell corresponding to a unit
    % each cell contains
    %1.time: time of all spike time in second
    %2.id: time of all spike time in second
    %1.time: time of all spike time in second
    %1.time: time of all spike time in second
    %1.time: time of all spike time in second
    unit_List=unique(clu);
    unit=cell(length(unit_List),1);

    for idx=1:length(unit_List)
        id=unit_List(idx);
        unit{idx}.time=spike.time(clu==id);
        unit{idx}.id=id;
    end
    unit_all{gidx}=unit;
end
