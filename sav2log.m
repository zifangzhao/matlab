function sav2log(filename,text,mode)
fh=fopen(filename,mode);
if(~iscell(text))
fprintf(fh,'%s\r\n',text);
else
    cellfun(@(x) fprintf(fh,'%s\r\n',x),text);
end
fclose(fh);