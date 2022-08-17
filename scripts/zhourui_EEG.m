% EEG analyzer for zhourui 
% @2013-5-14
manual_adjust=0; %delay time ms
time_pre=10000; %ms
plantform_period=4000;
loc_din4=arrayfun(@(x) strcmp(DIN_1(1,x),'DIN4'),1:size(DIN_1,2));
loc_din2=arrayfun(@(x) strcmp(DIN_1(1,x),'DIN2'),1:size(DIN_1,2));
t_din4=[DIN_1{2,loc_din4}]-manual_adjust;t_diff4=diff(t_din4);loc=1+find(t_diff4<500);t_din4(loc)=[];
t_din2=[DIN_1{2,loc_din2}]-manual_adjust;t_diff2=diff(t_din2);loc=1+find(t_diff2<500);t_din2(loc)=[];
for i=1:min([length(t_din4),length(t_din2)])
    t1(i,1)=t_din4(i);
    loc=find(t_din2>t_din4(i));
    t1(i,2)=t_din2(loc(1));
    t2(i,1)=t_din2(loc(1));
    t2(i,2)=t_din2(loc(1))+plantform_period;
end

res_ratio=10;  %fs_ori/fs
data_segs=cell(size(t1,1),1);
data_segs2=cell(size(t1,1),1);
for i=1:size(t1,1)
    data_segs{i}=data(:,t1(i,1)/res_ratio:t1(i,2)/res_ratio);
    data_segs2{i}=data(:,t2(i,1)/res_ratio:t2(i,2)/res_ratio);
end

%% data average
eeg2=zeros([size(data_segs2{1}) length(data_segs2)]);
for i=1:size(t1,1)
    eeg2(:,:,i)=data_segs2{i};
end
eeg2_avg=mean(eeg2,3);

[S2,F2,T2,P2]=spectrogram(eeg2_avg(25,:),100,95,100,100);
imagesc(T2,F2,10*log10(P2));axis xy;