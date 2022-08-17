% export filter to SOS,G and SOS1,G1

fs=20000;
cycle=3;
t_seg=(1:1*fs)/fs;
freq_h=100;
data=32767*chirp(t_seg,0,length(t_seg)/fs,freq_h);
data=reshape(data'*ones(1,cycle),1,[]);
data=int16(data); %original data is in int16
SOS=single(SOS); %parameters are store in single float
G=single(G);

data_fil=sosfilt(SOS,single(data));

%%
figure(1);

t=(1:length(data))/fs;
subplot(311);
plot(t,data);
hold on;
plot(t,data_fil,'r');
hold off
%  xlim([max(t)*0.5,max(t)])
 
 
 %%
 freq_list=1:freq_h;
f_h=@(x) abs(awt_freqlist(x,fs,freq_list,'Gabor'));
 P_raw=f_h(data);
P=f_h(data_fil);
 subplot(312)
 imagesc(t,freq_list,P_raw');
 axis xy;
 colormap jet;
 subplot(313)
 imagesc(t,freq_list,P');
 axis xy;
 colormap jet;
 
% figure(2);
fvtool(SOS);
xlim([0,100])

