function CE32_DAT_medianCommonModeRejection(filename,smooth_sample,dim)

if nargin<1
    [f,p]=uigetfile('*.dat');
    filename=[p,f];
end

if nargin<2
    t=inputdlg('Input median filter order');
    smooth_sample=str2num(t{1});
end

if nargin<3
    dim=1;
end

if(isempty(filename))
    [f,p]=uigetfile('*.dat');
    filename=[p,f];
end

if(isempty(smooth_sample))
    t=inputdlg('Input median filter order');
    smooth_sample=str2num(t{1});
end


[Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread(filename);


chunck=1e6;
ptr=0;
system(['del ' filename(1:end-4) '_fixed.dat']);
while ptr<Nsamples
    if(ptr+chunck<Nsamples)
        read_len=chunck;
    else
        read_len=Nsamples-chunck;
    end
    dat=readmulti_frank(filename,Nch,1:Nch,ptr,ptr+read_len-1);
    ptr=ptr+read_len;
    dat_fil=medfilt1(dat,smooth_sample,[],dim);
    sav2dat([filename(1:end-4) '_fixed.dat'],(dat-dat_fil)','a+');
end