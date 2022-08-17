%%matlab Units to clu & res file
% function nev2clu
[mtg_file,pth]=uigetfile('*.mtg');
load([pth mtg_file],'-mat');
mtg_chn=cell2mat(cellfun(@(x) x.channel,rat_montage,'Uniformoutput',0))';
f=cell(1);
[fn,p]=uigetfile('*.mat','Load NEV file', 'MultiSelect', 'on');
if ~iscell(fn)
    f{1}=fn;
else
    f=fn;
end
for f_idx=1:length(f)
    
    load([p f{f_idx}]);
    %%
    CH_list=unique(NEV.Data.Spikes.Electrode)';  %extract all the channel have spikes in the nev file
    CH_list=CH_list(ismember(CH_list,mtg_chn));  %compare the channel selection with predefined montage
    idx=CH_list;
    abs_idx=arrayfun(@(x) find(mtg_chn==x),CH_list);
    str=[];
    for s_idx=1:length(idx);
        str{s_idx}=[num2str(idx(s_idx)) '(' num2str(abs_idx(s_idx)) ')'];
    end
    % [s,v] = listdlg('PromptString','Select a channel:',...
    %     'ListString',str);
    % CH_list=idx(:);
    
    [f1 p1]=uigetfile('*.dat',['Target File For ' f{f_idx}]);
    fname=[p1 f1];
    
    %%
    if (~isempty(f1))&&(length(f1)>1);
        cd(p1);
        wave=cell(length(CH_list),1);
        parfor ich=1:length(CH_list)
            AllUnits=NEV.Data.Spikes.Electrode==CH_list(ich);  %extract the index from the spikes pointed to current channel
            unit_num=double(max(NEV.Data.Spikes.Unit(AllUnits)))+1; %get unit number from the spike file
            
            Fc=300;
            Fs=NEV.MetaTags.TimeRes;
            [b,a]=butter(3,2*Fc/Fs,'high'); %high pass filter coeffience generation
            t=(1:size(NEV.Data.Spikes.Waveform,1))/Fs*1000;
            for idx=1:unit_num
                unit_sel=AllUnits&(NEV.Data.Spikes.Unit==(idx-1));
                wave_temp=double(NEV.Data.Spikes.Waveform(:,find(unit_sel))');
                wave_temp=filtfilt(b,a,wave_temp')';
                wave{ich}{idx}=wave_temp;
            end
            neu_t=NEV.Data.Spikes.TimeStamp(:,find(AllUnits))';
            neu_c=NEV.Data.Spikes.Unit(:,find(AllUnits))';
            uname=[fname(1:end-4)  '.res.' num2str(abs_idx(ich)-1)];
            cname=[fname(1:end-4)  '.clu.' num2str(abs_idx(ich)-1)];
            dlmwrite(uname,round(1000/Fs*neu_t),'precision','%d','delimiter',' ');
            dlmwrite(cname,[unit_num ; neu_c],'precision','%d','delimiter',' ');
        end
    end
end