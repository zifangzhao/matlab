%script to calculate the Spectrum difference between ground channel and
%recording channel

[f1, p1]=uigetfile({'*.dat' ;'*.LFP'},'Select the LFP Recording file'); %%HD32C_test11_2.5K_50Mhz_animal_frank_5chn.eegstates
[f2, p2]=uigetfile({'*.dat' ;'*.LFP'},'Select the Noise Recording file');%%1106_test03
fs1=16e3;
Nchannel1=5;
data1=readmulti_frank([p1 f1],Nchannel1,1:Nchannel1,350*fs1,420*fs1);

fs2=16e3;
Nchannel2=5;
data2=readmulti_frank([p2 f2],Nchannel2,1:Nchannel2,270*fs2,300*fs2);
%%
data1=resample(data1,2500,fs1);
data2=resample(data2,2500,fs2);
%%
data1=data1/65536*3/200*1e6;
data2=data2/65536*3/200*1e6;
%%
[P1 f1]=awt_freqlist(data1(:,1),fs1,1:200,'Gabor');
[P2 f2]=awt_freqlist(data2(:,1),fs2,1:200,'Gabor');
%%
P1_avg=mean(abs(P1),1);
P2_avg=mean(abs(P2),1);
plot(f2,[P1_avg - P2_avg])

%%%
figure('Name','SNR')
P1_avg=mean(abs(P1),1).^2;
P2_avg=mean(abs(P2),1).^2;

subplot(1,2,1); loglog(f1,P1_avg); xlim([2 200]); hold on;
subplot(1,2,1); loglog(f2,P2_avg,'r'); xlim([2 200]);hold off

SNR=10 * log10(P1_avg-P2_avg);
subplot(1,2,2); semilogx(f2,SNR); xlim([1 200])







