%%
function [Xc,wave_band_mean]=WaveXcorr(wave,band,freqlist)
%Xc dim1: ch1 dim2 ch2 dim3 band1 dim4 band2
    Xc=zeros(size(wave,3),size(wave,3),length(band),length(band));
    wave=abs(wave);
    wave_band=zeros(size(wave,1),length(band),size(wave,3));
    for b_idx1=1:length(band)
        fsel=freqlist>=band{b_idx1}(1)&freqlist<=band{b_idx1}(2);
        wave_band(:,b_idx1,:)=mean(wave(:,fsel,:),2);
    end
    wave_band_mean=squeeze(mean(wave_band,1));
    for b_idx1=1:length(band)
        wave_mean1=mean(wave_band(:,b_idx1,:).^4,1);
        for b_idx2=1:length(band)   
            wave_mean2=mean(wave_band(:,b_idx2,:).^4,1);
            for idx1=1:size(wave,3)
                for idx2=idx1:size(wave,3)
                    %                     Xc(idx1,idx2,b_idx1,b_idx2)=mean(wave_band(:,b_idx1,idx1).*wave_band(:,b_idx2,idx2))./wave_mean1(idx1)./wave_mean2(idx2);
                    %                     Xc(idx1,idx2,b_idx1,b_idx2)=mean(wave_band(:,b_idx1,idx1).*wave_band(:,b_idx2,idx2))./mean(wave_band(:,b_idx1,idx1))./mean(wave_band(:,b_idx2,idx2));
                    Xc(idx1,idx2,b_idx1,b_idx2)=2*mean(wave_band(:,b_idx1,idx1).^2.*wave_band(:,b_idx2,idx2).^2)./(wave_mean1(idx1)+wave_mean2(idx2));
                end
            end
        end
    end
    