%% script for loading CE32 accelerometer data
[f,p]=uigetfile('*_aux.lfp');
data_misc=readmulti_frank([p f],8,2:4,0,inf);
%%
fs=1250;
[b,a]=butter(2,1/fs*2,'high');
data_misc_fil=abs(filtfilt(b,a,data_misc));
movement=sqrt(sum(data_misc_fil.^2,2));

%% combine files
lfp_name=[p f(1:end-8) '.lfp'];
data=readmulti_frank(lfp_name,32,1:32,0,inf);
data_movement=zeros(length(data),1);
min_len=min(length(data_movement),length(data_misc_fil));
data_movement(1:min_len)=movement(1:min_len);

data=[data data_movement];
sav2dat([lfp_name(1:end-4) '_combined.lfp'],data);

motionSignal=resample(data_movement,1,fs);
motionLength=floor(length(data)/fs);
motionSignal=motionSignal(1:motionLength);
save([lfp_name(1:end-4)],'motionSignal');