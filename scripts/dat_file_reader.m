%load dat format 
channel_num=32;
[f_name,pathname]=uigetfile('*.dat');
fid=fopen([pathname f_name]);
data=fread(fid,'int16');
data=reshape(data,32,[])*(5e-3/32767);
fclose(fid);