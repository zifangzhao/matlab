% export filter to SOS,G and SOS1,G1
%load base LPF filter
FIL1=LPF_20k_1250_DF_INT16;
FIL2=BPF_20K_1_4_DF_float_designer;
% BPF=BPF_20K_1_4_DF_float_designer;
% BPF=BPF_20K_4_8_DF_float_designer;
fs=20000;
cycle=3;
t_seg=(1:1*fs)/fs;
freq_h=100;
data=32767*chirp(t_seg,0,length(t_seg)/fs,freq_h);
data=reshape(data'*ones(1,cycle),1,[]);
data=int16(data); %original data is in int16

data_fil=filter(Num,Den,data);
% data_fil=filter(FIL1,data);
data_fil=data_fil(1:16:end);
% data_fil=filter(FIL2,data_fil);
% data_fil=filter(Num,Den,data_fil);
data_fil=double(data_fil);

fs_res=fs/16;
%%
figure(1);

t=(1:length(data))/fs;
t_res=(1:length(data_fil))/fs_res;
subplot(311);
plot(t,data);
hold on;
plot(t_res,data_fil,'r');
hold off
%  xlim([max(t)*0.5,max(t)])
 
 
 %%
 freq_list=1:freq_h;
f_h=@(x,fs) abs(awt_freqlist(x,fs,freq_list,'Gabor'));
 P_raw=f_h(data,fs);
P=f_h(data_fil,fs_res);
 subplot(312)
 imagesc(t,freq_list,P_raw');
 axis xy;
 colormap jet;
 subplot(313)
 imagesc(t_res,freq_list,P');
 axis xy;
 colormap jet;
 
% figure(2);