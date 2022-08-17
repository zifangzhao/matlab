
for idx=1:1e7
 data=sin(idx*pi/50*[1:500])*100;   
fp=fopen('b.dat','ab');
 fseek(fp,0,'eof');
fwrite(fp,[data],'int16');
fclose(fp);
 pause(0.01)
end