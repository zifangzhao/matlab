%CLear the noise based on clustering
function data_o=EEG_reference_by_cluster(data_o,Wn,percent)
idx=randperm(size(data_o,1));
data=data_o(idx(1:round(percent*end/100)),:);
[z,p,k] = butter(9,Wn,'low');  % Butterworth filter
[sos] = zp2sos(z,p,k);          % Convert to SOS form
% h = fvtool(sos);                % Plot magnitude response
data=filtfilt(sos,1,data)';
d_size=size(data);
data=zscore(reshape(data,[],1));
data=reshape(data,d_size);
% D=pdist(data);
% L=linkage(D);
% c2=cluster(L,'cutoff',1.2);
opts=statset('UseParallel',1);
[idx,~,~,d]=kmeans(data,2,'Replicates',5,'Options',opts);

d1=d(idx==1,1);
d2=d(idx==2,2);

[~,idx_max_1]=max(d1);
[~,idx_max_2]=max(d2);
data_o(:,idx==1)=data_o(:,idx==1)-data_o(:,idx_max_1)*ones(1,length(d1));
data_o(:,idx==2)=data_o(:,idx==2)-data_o(:,idx_max_2)*ones(1,length(d2));
% data_o(:,idx==1)=data_o(:,idx==1)-filtfilt(sos,1,data_o(:,idx_max_1)')'*ones(1,length(d1));
% data_o(:,idx==2)=data_o(:,idx==2)-filtfilt(sos,1,data_o(:,idx_max_2)')'*ones(1,length(d2));