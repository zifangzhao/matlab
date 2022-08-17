function sav2dat(fname,data,append_mode,format)
if nargin<3
    append_mode=0;
end
if nargin<4
    format = 'int16';
end
if append_mode==0
    mode='w+';
else
    mode='a+';
end

if size(data,2)<size(data,1)
    data=data';
end
fh=fopen(fname,mode);
fwrite(fh,data,format);
fclose(fh);
