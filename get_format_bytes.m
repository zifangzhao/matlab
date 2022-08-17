function len=get_format_bytes(format)
data=0;
fname='get_format_bytes_test';
fh=fopen(fname,'w+');
fwrite(fh,data,format);
fclose(fh);

fh=fopen(fname,'r+');
data=fread(fh,inf,'uint8');
fclose(fh);
if ispc
    system(['del ' fname]);
else
    system(['rm ' fname]);
end
len=length(data);
