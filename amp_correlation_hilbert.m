% Amplitude-Amplitude Crosscorrelation
function c=amp_correlation_hilbert(dataA,dataB)
AmpA=abs(hilbert(dataA));
AmpB=abs(hilbert(dataB));

Amean=sqrt(sum(AmpA.^2));
Bmean=sqrt(sum(AmpB.^2));
c= sum(AmpA.*AmpB)./Amean/Bmean;
% c=zeros(N);
% parfor idxA=1:N
% %     for idxB=1:N
% % %         c(idxA,idxB)=xcorr(AmpA(:,idxA),AmpB(:,idxB),maxlag);
% %         c(idxA,idxB)=mean(AmpA(:,idxA).*AmpB(:,idxB))./Amean(idxA)/Bmean(idxB);
% %     end
%     c(idxA,:)=arrayfun(@(idxB) mean(AmpA(:,idxA).*AmpB(:,idxB))./Amean(idxA)/Bmean(idxB),1:N);
% end

