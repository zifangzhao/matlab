function [data,ArModel] = DAT_whitenSignal(filename,ArModel,Nch,fs)
%% Whiten LFP signal
if nargin<2
    ArModel=[];
end

if nargin<3
    [Nch,fs,~,~,~,~]=DAT_xmlread(filename);
end

data=readmulti_frank(filename,Nch,1:Nch,0,inf);
[data,ArModel]=WhitenSignal(data,fs*2000,0,ArModel,1);
%%
fh=fopen([filename(1:end-4) '_whiten.lfp'],'w+');
fwrite(fh,data','int16');
fclose(fh);

