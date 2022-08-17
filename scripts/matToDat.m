%Script to convert cerebus matlab to dat

%file control
dir1=dir('*.*');
dir1=dir1([dir1.isdir]);
dir1(1:2)=[];
[s,v]=listdlg('PromptString','Select the folder to be processed','ListString',{dir1.name});
dir1=dir1(s);
% target_folder=['d:\wanlab\'];
target_folder=[uigetdir() '\'];
%find the global montage
dir_m=dir('*.mtg');
montage_exist=0;
if ~isempty(dir_m)
    montage_exist=1;
    load(dir_m(1).name,'-mat');
    mtg_chn=cell2mat(cellfun(@(x) x.channel,rat_montage,'Uniformoutput',0))';
end
multiWaitbar('Close all')
for d_idx=1:length(dir1)
    multiWaitbar('Dir',d_idx/length(dir1));
    cd(dir1(d_idx).name);
    filelist=dir('*_raw.mat');
    mkdir([target_folder dir1(d_idx).name]);
    for f_idx=1:length(filelist)
        multiWaitbar('File',f_idx/length(filelist));
        data=load(filelist(f_idx).name);
        varlist=fieldnames(data);
        current_elec_list=zeros(length(varlist)+1,1);
        elec_idx=1;
        for idx=1:length(varlist)
            if length(varlist{idx})>=5
                if isequal(varlist{idx}(1:4),'elec') && isempty(regexp(varlist{idx},'_', 'once'))
                    current_elec_list(elec_idx)=str2double(regexp(varlist{idx},'\d*','match'));
                    elec_idx=elec_idx+1;
                end
            end
        end
        
        current_elec_list(elec_idx:end)=[];
        current_elec_list=sort(current_elec_list);
        chnfname=filelist(f_idx).name;
        chnfname=[target_folder dir1(d_idx).name '\' chnfname(1:end-4) '_chnlist'];
        elec_list=current_elec_list;
        channel_map=1:length(elec_list);
        if montage_exist
            channel_map=arrayfun(@(x) find(mtg_chn==x),elec_list);
            elec_list=mtg_chn;
        end
        save(chnfname,'elec_list')
        chunk_size=1e5;
        fs=1000;
        txt_idx=1;
        trigger_on=0;
        trigger_time=0.03; %in second
        % new_name=uiputfile([filename ], 'Save to new dat file');
        fname=[target_folder dir1(d_idx).name '\' filelist(f_idx).name];
        fname=[fname(1:end-3) 'dat'];
        f=fopen(fname,'w+');
        temp=zeros(length(current_elec_list)+1,chunk_size);
        len=length(getfield(data,['elec' num2str(current_elec_list(1))]));
        ainp1_on=strfind(varlist,'ainp1_unit32');
        if ~isempty([ainp1_on{:}])
            trigger_on=1;
            trigger=zeros(1,len);
            for aidx=1:length(data.ainp1_unit32)
                if round(data.ainp1_unit32(aidx)*fs)+trigger_time*fs<=len
                    trigger(round(data.ainp1_unit32(aidx)*fs):round(data.ainp1_unit32(aidx)*fs+trigger_time*fs))=1;
                else
                    trigger(round(data.ainp1_unit32(aidx)*fs):end)=1;
                end
            end
        end
        % eval(['len=length(elec' num2str(elec_list(1)) ');']);
        while txt_idx<len
            if txt_idx+chunk_size>len
                chunk=len-txt_idx;
                temp=zeros(length(elec_list)+1,chunk);
            else
                chunk=chunk_size;
            end
            for chn=1:length(current_elec_list)
                temp(channel_map(chn),1:chunk)=eval(['data.elec' num2str(current_elec_list(chn)) '(txt_idx:txt_idx+chunk-1)']);
            end
            temp=temp./200;
            if trigger_on
                temp(length(elec_list)+1,1:chunk)=trigger(txt_idx:txt_idx+chunk-1)*1000;
            end
            fwrite(f,temp,'int16');
            txt_idx=txt_idx+chunk;
        end
        
        fclose(f);
        %% write event file
        filename=[target_folder dir1(d_idx).name '\' filelist(f_idx).name ];
        starts=data.ainp1_unit32';
        mid=starts+15/1000;
        ends=starts+30/1000;
        starts=starts;
        mid=mid;
        ends=ends;
        events.time=reshape([starts ;mid;ends],1,[]);
        events.description=arrayfun(@(x) ['IED start ' ],1:3*length(starts),'UniformOutput',0);
        events.description(2:3:end)=arrayfun(@(x) ['IED peak ' ],1:length(ends),'UniformOutput',0);
        events.description(3:3:end)=arrayfun(@(x) ['IED stop ' ],1:length(ends),'UniformOutput',0);
        system(['del "' [filename(1:end-4) '.stm.evt"']]);
        SaveEvents([filename(1:end-4) '.stm.evt'],events);
        
        %% if bhv file exists
         fname=filelist(f_idx).name;
         bhvfile=dir([fname(1:end-7) 'bhv.xls']);
         if ~isempty(bhvfile)
             bhv=importdata(bhvfile.name);
             starts=bhv(:,1)';
             mid=starts+15/1000;
             ends=starts+30/1000;
             starts=starts;
             mid=mid;
             ends=ends;
             events.time=reshape([starts ;mid;ends],1,[]);
             events.description=arrayfun(@(x) ['IED start ' ],1:3*length(starts),'UniformOutput',0);
             events.description(2:3:end)=arrayfun(@(x) ['IED peak ' ],1:length(ends),'UniformOutput',0);
             events.description(3:3:end)=arrayfun(@(x) ['IED stop ' ],1:length(ends),'UniformOutput',0);
             system(['del "' [filename(1:end-4) '.bhv.evt"']]);
             SaveEvents([filename(1:end-4) '.bhv.evt'],events);
         end
    end
    cd('..');
end
multiWaitbar('Close all')
