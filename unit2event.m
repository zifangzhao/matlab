%%matlab Units to event file
fname=uigetfile('*.mat');
load(fname);
idx=find(~cellfun(@isempty,units));
str=num2str(idx);
[s,v] = listdlg('PromptString','Select a channel:',...
                'ListString',str);
ch_sel=idx(s);
fs=1000;
for ch_idx=1:length(ch_sel);
    ch=ch_sel(ch_idx);
    unit=units{ch};
    for u_idx=1:length(unit)
        u_num=num2str(1000+u_idx);
        uname=[fname(1:end-4) '_CH' num2str(ch) '_UNIT' num2str(u_idx) '.s' u_num(3:end) '.evt'];
        spk=unit{u_idx}*[ 1 1 1];
        events.time=spk';
        events.description=arrayfun(@(x) ['SPK start ' ],1:3*size(spk,1),'UniformOutput',0);
        events.description(2:3:end)=arrayfun(@(x) ['SPK peak ' ],1:size(spk,1),'UniformOutput',0);
        events.description(3:3:end)=arrayfun(@(x) ['SPK stop ' ],1:size(spk,1),'UniformOutput',0);
        system(['del "'  uname   '"']);
        SaveEvents(uname,events);
    end
end