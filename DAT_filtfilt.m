function DAT_Filter(filename,b,a,dim)

if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p,f];
end



if nargin<4
    dim=5;
end

if(isempty(filename))
    [f,p]=uigetfile('*.dat');
    filename=[p,f];
end



[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread(filename);
data=readmulti_frank(filename,Nch,1:Nch,0,inf);
data=filtfilt(b,a,data);
% system(['del ' filename(1:end-4) '_filtered.dat']);
% sav2dat([filename(1:end-4) '_filtered.dat'],data,'w+');
system(['del ' filename(1:end-4) '.lfp']);
sav2dat([filename(1:end-4) '.lfp'],data,'w+');