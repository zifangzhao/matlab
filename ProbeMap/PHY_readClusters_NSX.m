%% Get Cluster infomation from Kwik format HDF5
function unit_all=PHY_readClusters_NSX(filename)
if(nargin<1 || isempty(filename))
    [f,p]=uigetfile('*.kwik');
    filename=[p,f];
end
kwxfile=[filename(1:end-4) 'kwx'];
ns6_file=[filename(1:end-4) 'ns6'];
dat_file=[filename(1:end-4) 'dat'];
fileinfo=hdf5info(filename);
grp_count=length(fileinfo.GroupHierarchy.Groups(2).Groups);
disp(['Opening kwik file, found ' num2str(grp_count) ' channel groups']);

unit_all=cell(grp_count,1);
for gidx=1:grp_count
    time=double(hdf5read(filename, ['/channel_groups/' num2str(gidx-1) '/spikes/time_samples']))+1;
    clu=hdf5read(filename, ['/channel_groups/' num2str(gidx-1) '/spikes/clusters/main']);
    clu_name={fileinfo.GroupHierarchy.Groups(2).Groups(1).Groups(3).Groups(1).Groups.Name};
    clu_id=cellfun(@(x) str2num(strrep(x,['/channel_groups/' num2str(gidx-1) '/clusters/main/'],[])),clu_name);
    clu_label=arrayfun(@(x) x.Attributes.Value,fileinfo.GroupHierarchy.Groups(2).Groups(gidx).Groups(3).Groups(1).Groups(:));
    
    % Filter clu by label 0=noise;1=MUA;2=Good;3=Unsorted
    clu_id_valid=clu_id(ismember(clu_label,[2 3]));  %Change here for selecting groups
    clu=clu(ismember(clu,clu_id_valid)); %keep only valid clusters
    
    featuremask=hdf5read(kwxfile,['/channel_groups/' num2str(gidx-1) '/features_masks']);
    fs=20e3;
    Nch=32;
    %% recovery matrix
    NSX=openNSx(ns6_file,'noread');
    TimeStamp=round(NSX.MetaTags.Timestamp*20e3/30e3);
    Duration=round(NSX.MetaTags.DataPoints/3*2);
    % load([p f(1:end-5) '_timestamp.mat']);
    tx=arrayfun(@(x,y) x+(1:y),TimeStamp,Duration,'uni',0);
    tx=cat(2,tx{:});
    time(time>length(tx))=[];
    spike.time=tx(time)/fs; %time in second
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
    [b,a]=butter(2,500/2e4*2,'high');
    for idx=1:length(unit_List)
        id=unit_List(idx);
        unit{idx}.time=spike.time(clu==id);
        unit{idx}.id=id;
        unit{idx}.features=(featuremask(1,:,clu==id));
        mean_feature=mean(unit{idx}.features,3);
        [~,ix]=max(mean_feature,[],2);
        unit{idx}.MaxAmplitudeChannel=ceil(ix/3);
        unit{idx}.MeanAmp=sum(abs(reshape(mean_feature,3,[])),1);
        all_waveform=arrayfun(@(x) readmulti_frank(dat_file,Nch,1:Nch,x-50,x+50),time(clu==id),'uni',0);
        lens=cellfun(@length,all_waveform);
        all_waveform(lens~=max(lens))=[];
        all_waveform=cellfun(@(x) filtfilt(b,a,x),all_waveform,'uni',0);
        unit{idx}.Waveform=cellfun(@(x) x(50-16:50+16,:),all_waveform,'uni',0);
        all_waveform=cat(3,unit{idx}.Waveform{:});
        unit{idx}.AverageWaveform=mean(all_waveform,3);
        unit{idx}.RepresentativeWaveform=unit{idx}.AverageWaveform(:,unit{idx}.MaxAmplitudeChannel);
    end
    unit_all{gidx}=unit;
end
