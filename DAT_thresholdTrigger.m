function locs=DAT_thresholdTrigger(sig,threshold,duration)
if size(sig,1)~=1
    sig=sig';
end
% detect low threshold
sigL = sig>threshold(1);
sigL = imclose(sigL,strel('line',duration,90));
sigL = diff([0 sigL]);
locs = find(sigL ==1);
loc_exceed=[];
if length(threshold)>1
    for idx =1:length(locs)
       index = locs(idx):(locs(idx)+duration);
       index(index>length(sig))=[];
       if max(sig(index)>threshold(2))
           loc_exceed=[loc_exceed idx];
       end
    end
end
locs(loc_exceed)=[];


