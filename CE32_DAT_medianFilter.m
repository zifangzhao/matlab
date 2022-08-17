function CE32_DAT_medianFilter(filename,dim)

if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p,f];
end



if nargin<2
    dim=5;
end

if(isempty(filename))
    [f,p]=uigetfile('*.dat');
    filename=[p,f];
end



[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread(filename);
data=readmulti_frank(filename,Nch,1:Nch,0,inf);
data=medfilt1(data,dim);
system(['del ' filename(1:end-4) '_MedianNoiseReject.dat']);
sav2dat([filename(1:end-4) '_MedianNoiseReject.dat'],data,'w+');
