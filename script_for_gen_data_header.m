fs=1000;data=chirp((0:fs*10-1)/fs,0,10,fs/2);
data_str=arrayfun(@(x) [num2str(x),','],data,'uni',0);
data_str=[data_str{:}];
fh=fopen('waveform.h','w+');
fprintf(fh,'%s','float[] wave = [');
fprintf(fh,'%s',data_str);
fprintf(fh,'%s\r\t','];');
fclose(fh);