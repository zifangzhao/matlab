function [starts_n ends_n]=noise_eject(data,system_fs,starts,ends,trim_len,n_level)
starts_n=[];
ends_n=[];
if isempty(trim_len)
    for trial=1:length(starts)
        idx_start=round(starts(trial).*system_fs);
        idx_end=round(ends(trial).*system_fs);
        if length(data{1})>idx_end
            if ~sum(cellfun(@(x) sum(abs(x(idx_start:idx_end))>n_level),data))
                starts_n=[starts_n starts(trial)];
                ends_n=[ends_n ends(trial)];
            end
        end
    end
else
    for trial=1:length(starts)
        idx_start=round(starts(trial).*system_fs);
        if length(data{1})>idx_start+trim_len
            if ~sum(cellfun(@(x) sum(abs(x(idx_start:idx_start+trim_len))>n_level),data))
                starts_n=[starts_n starts(trial)];
                ends_n=[ends_n ends(trial)];
            end
        end
    end
end