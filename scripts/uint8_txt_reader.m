[f_n,p_n]=uigetfile('*.txt');
f_id=fopen([p_n f_n]);
dat=fread(f_id,[1 1000],'uint8');
fclose(f_id);