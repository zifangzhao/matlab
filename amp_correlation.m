% Amplitude-Amplitude Crosscorrelation
function c=amp_correlation(dataA,dataB,fs,freq,maxlag)
AmpA=abs(awt_freqlist(dataA,fs,freq,'Gabor'));
AmpB=abs(awt_freqlist(dataB,fs,freq,'Gabor'));
N=length(freq);

% c1=zeros(N);
Amean=mean(AmpA,1);
Bmean=mean(AmpB,1);

[X,Y]=meshgrid(1:N,1:N);
c=arrayfun(@(idxA,idxB) median(AmpA(:,idxA).*AmpB(:,idxB))./Amean(idxA)/Bmean(idxB),X,Y);
% c=zeros(N);
% parfor idxA=1:N
% %     for idxB=1:N
% % %         c(idxA,idxB)=xcorr(AmpA(:,idxA),AmpB(:,idxB),maxlag);
% %         c(idxA,idxB)=mean(AmpA(:,idxA).*AmpB(:,idxB))./Amean(idxA)/Bmean(idxB);
% %     end
%     c(idxA,:)=arrayfun(@(idxB) mean(AmpA(:,idxA).*AmpB(:,idxB))./Amean(idxA)/Bmean(idxB),1:N);
% end

