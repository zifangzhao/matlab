function c=amp_correlation_gpu(dataA,dataB,fs,freq,maxlag)
AmpA=gpuArray(abs(awt_freqlist(dataA,fs,freq,'Gabor')));
AmpB=gpuArray(abs(awt_freqlist(dataB,fs,freq,'Gabor')));
N=length(freq);
c=gpuArray(zeros(N));
for idxA=1:N
    for idxB=1:N
        c(idxA,idxB)=xcorr(AmpA(:,idxA),AmpB(:,idxB),maxlag);
    end
end
c=gather(c);