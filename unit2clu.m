%%matlab Units to clu & res file
fname=uigetfile('*_units.mat');
load(fname);
idx=find(~cellfun(@isempty,units));
str=num2str(idx-1);
[s,v] = listdlg('PromptString','Select a channel(base=0):',...
                'ListString',str);
ch_sel=idx(s);
fs=1000;
for ch_idx=1:length(ch_sel);
    ch=ch_sel(ch_idx);
    unit=units{ch};
    unit_mat=ones(sum(cellfun(@length,unit)),2);
    currentidx=1;
    for u_idx=1:length(unit)
        unit_mat(currentidx:currentidx+length(unit{u_idx})-1,1)=unit{u_idx};
        unit_mat(currentidx:currentidx+length(unit{u_idx})-1,2)=u_idx;
        currentidx=currentidx+length(unit{u_idx});
%         u_num=num2str(1000+u_idx);
%         uname=[fname(1:end-4) '_CH' num2str(ch) '_UNIT' num2str(u_idx) '.spk.' u_num(2:end) '.evt'];
    end
    unit_mat=sortrows(unit_mat,1);
    uname=[fname(1:end-4)  '.res.' num2str(ch-1)];
    cname=[fname(1:end-4)  '.clu.' num2str(ch-1)];
    dlmwrite(uname,round(fs*unit_mat(:,1)),'precision','%d','delimiter',' ');
    dlmwrite(cname,[length(unit) ; unit_mat(:,2)],'precision','%d','delimiter',' ');
end