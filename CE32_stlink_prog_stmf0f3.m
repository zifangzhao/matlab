%
[f,p]=uigetfile('*.bin');
cd(p);
stlink_prog='"C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\ST-LINK_CLI.exe"';
% prog_loc='I:\My_Works\uC\Arm_projects\HD128\CL04_Lite_stm32F373\CL04_Lite\MDK-ARM\CL04_Lite\CL04_Lite.bin';
prog_loc=[p f];
key_hex='3264';
key=hex2dec(key_hex);
%connect to st-link
uid_addr='0x1FFFF7AC';
[~,rst]=system([stlink_prog ' -c SWD  -r32 ' uid_addr ' 9']);
start_idx=strfind(rst,uid_addr);
UID_hex=regexpi(rst(start_idx:end),' \w{8}','match');
UID=cellfun(@hex2dec,UID_hex);
UID_encryp=bitxor(UID,key);
%read encryption code
% [~,rst]=system([stlink_prog ' -r32 0x1ffff7ac 3']);

%find compare ID in binary file
fh=fopen(prog_loc,'r+');
data=fread(fh,'uint32');
fclose(fh);

default_uid={'07080808','08080808','08080809'};
locater=cellfun(@hex2dec,default_uid);
loc=arrayfun(@(x) data==x,locater,'uniformOutput',0);

loc_final=ones(length(data),1);
for idx=1:length(loc)
    temp=loc{idx};
    temp=[temp(idx:end) ;zeros(idx-1,1)];
    loc_final=loc_final.*temp;
end
UIDinFile=find(loc_final);

ftgt=[prog_loc(1:end-4) '_target.bin'];
fh=fopen(ftgt,'w+');
fwrite(fh,data(1:UIDinFile-1),'uint32');
fwrite(fh,UID_encryp,'uint32');
fwrite(fh,data(UIDinFile+3:end),'uint32');
fclose(fh);

system([stlink_prog ' -c SWD  -P ' ftgt ' 0x8000000']);
system(['del ' ftgt]);

fh=fopen('c:\STM32_programming_record.csv','a');
fprintf(fh,'%s\n',[datestr(now),',',num2str(uid_addr),',',num2str(UID),',',UID_hex{:},',',num2str(UID_encryp),',',[p f],',',num2str(key)]);
fclose(fh);