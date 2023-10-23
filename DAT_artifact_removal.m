function data = DAT_artifact_removal(data,idx_st,idx_ed,avg_sps,smooth_sps)
if nargin<4
    avg_sps=5;
end
if nargin<5
    smooth_sps=5;
end
% input has to be a Samples X Nch array
idx = false(size(data,1),1);
idx(idx_st:idx_ed) = true; %select a range to process
surrogate_value = mean(data(1:idx_st,:));
sps = min([idx_ed+avg_sps,length(data)]);
end_value = mean(data(idx_ed:sps,:));
offset = end_value-surrogate_value;
data(idx,:)=surrogate_value; %replace noise period with starting value
data(idx_ed:end,:) = bsxfun(@minus,data(idx_ed:end,:),offset); %remove offset after stim
idx=DAT_morphOperation(@imdilate,idx,smooth_sps);%expanding selection region;
b = ones(smooth_sps,1)/smooth_sps;
data(idx,:) = filtfilt(b,1,data(idx,:));
