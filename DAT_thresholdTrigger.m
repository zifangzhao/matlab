function locs=DAT_thresholdTrigger(sig,threshold,duration)
trig = sig>threshold;
trig = imclose(trig,strel('line',duration,90));
trig_diff = diff([0 trig]);
locs = find(trig_diff ==1);