function data = DAT_artifact_removal(data,idx_st,idx_ed,avg_sps)
if nargin<4
    avg_sps=5;
end
% input has to be a Samples X Nch array
idx = false(size(data,1),1);
idx(idx_st:idx_ed) = true;
surrogate_vale = mean(data(1:idx_st,:));
sps = min([idx_ed+avg_sps,length(data)]);
end_value = mean(data(idx_ed:sps,:));
offset = end_value-surrogate_vale;
data(idx,:)=surrogate_vale; %replace noise period with starting value
data(idx_ed:end,:) = bsxfun(@minus,data(idx_ed:end,:),offset);
