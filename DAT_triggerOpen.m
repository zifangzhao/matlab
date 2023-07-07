function sig_proc=DAT_triggerOpen(sig,duration)

sig_proc = imopen(sig,strel('line',duration,90));