%% load file
[f,p]=uigetfile('*.dat');
fs=1000;
start_time=5; % read start time in Seconds
end_time=60; % read stop time in Seconds
gain=300/1e6; %gain in the system and convert to uV by div 1e6
data=readmulti_frank([p f],32,ch_sel,start_time*fs,end_time*fs)/gain;

%% filtering
filter_range=[8 12]; %filter for alpha
[b,a]=butter(3,[filter_range(1)/fs*2,filter_range(2)/fs*2],'bandpass');
data_fil=filtfilt(b,a,data);

%% plotting
t=(1:length(data))/fs;
figure(1);
subplot(211)
plot(t,data)
xlabel('Time(s)')
ylabel('Voltage(uV)');
title('Raw')
subplot(212)
plot(t,data_fil)
xlabel('Time(s)')
ylabel('Voltage(uV)');
title('Filtered')
%% plotting spectrum
data_ls=resample(data,200,fs); %down sampling to reduce data Size
freq_list=1:50; %frequency range in time-frequency plot
P=awt_freqlist(data_ls,200,freq_list,'Gabor');
t_low=(1:length(data_ls))/200;
figure(2)
imagesc(t_low,freq_list,abs(P))
axis tight;
axis xy;
xlabel('Time(s)')
ylabel('Frequency(Hz)');
colorbar