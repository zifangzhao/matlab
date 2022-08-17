function Waveform= WaveformCharacterization(spikes,plotting)

if nargin<2
    plotting=0;
end
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
    
    %     if(median(wave)>0)
    %         wave=-wave;
    %     end
    
    I2=[];
    I3=[];
    I4=[];
    
    [pksN,locsN,~,pN]=findpeaks(-wave);
    
    [~,idx]=max(pN);
    MIN2=-pksN(idx);
    I2=locsN(idx);
    if(isempty(I2))
        [MIN2,I2] = min(wave);
    end
    
    if(I2>2)
        [pks1,locs1,~,p1]=findpeaks(wave(1:I2));
        [~,idx1]=max(locs1);
        MAX3=pks1(idx1);
        I3=locs1(idx1);
    end
    
    if(I2<length(wave)-2)
        [pks2,locs2,~,p2]=findpeaks(wave(I2:end));
        [~,idx2]=min(locs2);
        MAX4=pks2(idx2);
        I4=locs2(idx2);
    end
    
    if(isempty(MAX3))
        [MAX3,I3] = max(wave(1:I2));
    end
    if(isempty(MAX4))
        [MAX4,I4] = max(wave(I2:end));
    end
    I4= I4 -1;
    PeaktoTrough(m) = I2-I3;
    TroughtoPeak(m) = I4;
    peakA(m) = MAX3;
    peakB(m) = MAX4;
    trough(m) = MIN2;
    
    %     plot(wave);hold on; plot([I2,I3,I2+I4],1,'>');hold off;pause;
    clear MIN2 MAX3 MAX4 I2 I3 I4
end

Waveform.PeaktoTrough = (PeaktoTrough/(Fs*2))';
Waveform.TroughtoPeak = (TroughtoPeak/(Fs*2))';
Waveform.peakA = peakA';
Waveform.peakB = peakB';
Waveform.AB_ratio = ((peakB-peakA)./(peakA+peakB))';
% Waveform.filtWaveform.trough = (trough)';
%
if plotting
    figure('units','normalized','outerposition',[0 0 1 1]);
    scatter((1e3)*Waveform.TroughtoPeak,Waveform.AB_ratio,300,'r.');
    xlabel('Trough-to-peak latency in ms'); ylabel('Waveform asymmetry'); set(gca,'fontsize',20);
    title('Waveform features from filtered waveforms'); 
end


