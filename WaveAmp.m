function Xc=WaveAmp(wave,band,freqlist)
    Xc=zeros(size(wave,3),length(band));
    wave=abs(wave);
    wave_band=zeros(size(wave,1),length(band),size(wave,3));
    for b_idx=1:length(band)
        fsel=freqlist>=band{b_idx}(1)&freqlist<=band{b_idx}(2);
        wave_band(:,b_idx,:)=median(wave(:,fsel,:),2);
    end
    
    for b_idx=1:length(band)
        wave_mean=median(wave_band(:,b_idx,:),1);
        for idx1=1:size(wave,3)
            for idx2=idx1:size(wave,3)
                Xc(idx1,idx2,b_idx)=median(wave_band(:,b_idx,idx1).*wave_band(:,b_idx,idx2))/wave_mean(idx1)/wave_mean(idx2);
            end
        end
    end
    