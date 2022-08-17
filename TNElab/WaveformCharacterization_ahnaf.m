function Waveform= WaveformCharacterization_ahnaf(spikes)

% spikes.filtWaveform= mean waveform (filtered)
% Output: 
% Waveform.peakA= Left peak
% Waveform.peakB= Right peak
% Waveform asymmetry= Waveform.AB_ratio
% Waveform.TroughtoPeak= Trough to peak latency (i.e. negative minimum to peak B distance)
% Waveform.PeaktoTrough= Peak to trough latency (i.e. peak A to negative minimum distance)

Fs = 2e4; % Sampling rate 

N= length(spikes.filtWaveform); 
for i = 1:N
    filtWaveforms(i,:) = spikes.filtWaveform{i};
end

wave = []; PeaktoTrough = zeros(1,N); TroughtoPeak = zeros(1,N); peakA =zeros(1,N); peakB = zeros(1,N); trough = zeros(1,N);
for m = 1:N
    wave = interp1([1:size(filtWaveforms,2)],zscore(filtWaveforms(m,:)),[1:0.5:size(filtWaveforms,2),size(filtWaveforms,2)],'spline');
    [MIN2,I2] = min(wave); 
    [MAX3,I3] = max(wave(1:I2)); 
    [MAX4,I4] = max(wave(I2:end)); 
    I4= I4 -1;
    PeaktoTrough(m) = I2-I3;
    TroughtoPeak(m) = I4;
    peakA(m) = MAX3;
    peakB(m) = MAX4;
    trough(m) = MIN2;
    clear MIN2 MAX3 MAX4 I2 I3 I4
end
Waveform.PeaktoTrough = (PeaktoTrough/(Fs*2))';
Waveform.TroughtoPeak = (TroughtoPeak/(Fs*2))';
Waveform.peakA = peakA';
Waveform.peakB = peakB';
Waveform.AB_ratio = ((peakB-peakA)./(peakA+peakB))';
% Waveform.filtWaveform.trough = (trough)';

figure('units','normalized','outerposition',[0 0 1 1]);
scatter((1e3)*Waveform.TroughtoPeak,Waveform.AB_ratio,300,'r.');
xlabel('Trough-to-peak latency in ms'); ylabel('Waveform asymmetry'); set(gca,'fontsize',20);
title('Waveform features from filtered waveforms');




