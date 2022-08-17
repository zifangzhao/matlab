%% noise detect
function DAT_common_mode_extract(filename)
if nargin<1
    [f,p]=uigetfile('*.fil','*.fil| fil file to be processed');
    filename=[p f];
end
[Nch,fs,Nsamples,~,good_ch]=DAT_xmlread([filename]);
fh=fopen([filename(1:end-4) '_spkCommonMode.dat'],'w+');
buffer=50e3;
ptr=0;
multiWaitbar('Calculating common mode:',0);
while ptr<Nsamples
    data=readmulti_frank([filename],Nch,good_ch,ptr,ptr+buffer-1);
    data_mean=mean(data,2);
    fwrite(fh,data_mean','int16');
    ptr=ptr+buffer;
    multiWaitbar('Calculating common mode:',ptr/Nsamples);
end
multiWaitbar('close all');
fclose(fh);