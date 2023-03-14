function sig_proc=DAT_triggerClose(sig,duration)

sig_proc = imclose(sig,strel('line',duration,90));