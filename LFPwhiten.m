%% Whiten LFP signal
[f,p]=uigetfile('*.lfp');
[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread([p f]);
data=readmulti_frank([p f],Nch,1:32,0,inf);
data=WhitenSignal(data,fs*2000,0,[],1);
%%
fh=fopen([p f(1:end-4) '_whiten.lfp'],'w+');
fwrite(fh,data','int16');
fclose(fh);

