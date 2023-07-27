function [data,ArModel] = DAT_whitenSignal(filename,ArModel,Nch,fs,sps_start,sps_end)
%% Whiten LFP signal
if nargin<2
    ArModel=[];
end

if nargin<3
    [Nch,fs,~,~,~,~]=DAT_xmlread(filename);
end

if nargin<5
    sps_start = 0;
end
if nargin<6
    sps_end = inf;
end
data=readmulti_frank(filename,Nch,1:Nch,0,inf);
if isempty(ArModel)
    [~,ArModel]=WhitenSignal(data(sps_start:end,:),fs*1000,0,ArModel,1);
end
[data,~]=WhitenSignal(data,fs*1000,0,ArModel,1);
%%
% fh=fopen([filename(1:end-4) '_whiten.lfp'],'w+');
% fwrite(fh,data','int16');
% fclose(fh);
sav2dat([filename(1:end-4) '_whiten.lfp'],data);
