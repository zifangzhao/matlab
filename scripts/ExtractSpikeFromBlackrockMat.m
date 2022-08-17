%%extract spike time from wanlab .mat format

[mtg_file,pth]=uigetfile('*.mtg');
load([pth mtg_file],'-mat');
target_dir=['d:\wanlab\'];
mtg_chn=cell2mat(cellfun(@(x) x.channel,rat_montage,'Uniformoutput',0))';
cwd=pwd;

dirlist=dir('*.*');
dirlist=dirlist([dirlist.isdir]);
dirlist(1:2)=[];
for d_idx=1:length(dirlist)
    dirname=dirlist(d_idx).name;
    cd(dirname);
    filelist=dir('*raw.mat');
    for f_idx=1:length(filelist)
        units=cell(length(mtg_chn),1);
        fname=filelist(f_idx).name;
        varlist=who('-file',fname);
        unit_t=cellfun(@(x) ~isempty(x),strfind(varlist,'unit'));
        elec_t=cellfun(@(x) ~isempty(x),strfind(varlist,'elec'));
        unitlist=varlist(elec_t&unit_t);
        unit_channel=cell2mat(cellfun(@(x) str2double(regexp(x,'\d*','match')),unitlist,'UniformOutput',0)); %%the first column will be the channel number , the next will be the unit idx
        unit_channel_unique=unique(unit_channel(:,1));
        
        channel_map=arrayfun(@(x) find(mtg_chn==x),unit_channel(:,1));
        
        for idx=1:length(unit_channel_unique)
            locs=find(unit_channel(:,1)==unit_channel_unique(idx));
            ind=1:length(locs);
            unit_channel(locs,2)=ind;
        end
        unit_map=arrayfun(@(x) find(mtg_chn==x),unit_channel(:,1));
        for u_idx=1:length(unitlist)
            temp=load(filelist(f_idx).name,unitlist{u_idx});
            v_name=fieldnames(temp);
            units{channel_map(u_idx)}{unit_channel(u_idx,2)}=getfield(temp,v_name{1});
        end
        save([target_dir dirname '\' fname(1:end-4) '_units'],'units')
    end
    cd(cwd);
end