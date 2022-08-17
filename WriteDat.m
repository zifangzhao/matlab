%WriteDat
function WriteDat(filename,data,format)
if nargin<3
    format='int16';
end

fh=fopen(filename,'w+');
fwrite(fh,data,format);
fclose(fh);
