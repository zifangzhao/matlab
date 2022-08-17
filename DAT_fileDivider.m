%% Script for dividing binary data files
function DAT_fileDivider()
prompt = {'Channel Count (IMPORTANT):','Divided file size (GB)'};
dlgtitle ='Dividing binary data file into smaller files';
dims = [1 80];
definput = {'32','4'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
Nch=str2num(answer{1});
divSize=str2num(answer{2})*(2^30);

[files,pth]=uigetfile({'*.dat;*.lfp;*.bin','Binary format data';'*.*','Others'},'multiselect','on');
if ~iscell(files)
    temp=files;
    files={temp};
end

%% dividing file
memSize=2^28;
N_chunk=divSize/memSize;
for f_idx=1:length(files)
    filename=[pth files{f_idx}];
    [p,f,ext]=fileparts(filename);
    filebase=[p filesep f];
    fsize=getfileInfo(filename);
    current_loc=1;
    file_id=1;
    txt=sprintf('Dividing file (%d/%d):%s',f_idx,length(files),filename);
    disp(txt);
    while(current_loc<fsize)
        subfile=[filebase '_' num2str(file_id) ext];
        sav2dat_inline(subfile,[]);%create file
        for c_idx=1:N_chunk
            DTW=readmulti_inline(filename,Nch,1:Nch,current_loc/Nch/2,(current_loc+memSize)/Nch/2);
            sav2dat_inline(subfile,DTW,1);
            current_loc=current_loc+memSize;
        end
        file_id=file_id+1;
    end
end

function sav2dat_inline(fname,data,append_mode)
if nargin<3
    append_mode=0;
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
fwrite(fh,data,'int16');
fclose(fh);



function fsize=getfileInfo(filename)
    fdir=dir(filename);
    fsize=fdir(1).bytes;
    
function [eeg,fb] = readmulti_inline(fname,numchannel,chselect,read_start,read_until,precision,b_skip)
% eeg is output, fb is size of file in bytes
% Reads multi-channel recording file to a matrix
% last argument is optional (if omitted, it will read all the 
% channels.
%
% From the Buzsaki lab (obtained 4/5/2010).
% revised by zifang zhao @ 2014-5-1 increased 2 input to
% control the range of file reading
read_start=round(read_start);
read_until=round(read_until);
if nargin<6 %precision and skip 
    precision='int16';
end
if nargin<7 %skip
    b_skip=0;
end
 fileinfo = dir(fname);
if nargin == 2
 datafile = fopen(fname,'r');
 eeg = fread(datafile,[numchannel,inf],'int16');
 fclose(datafile);
 eeg = eeg';
 return
end
fb=fileinfo(1).bytes;
byte_len=get_format_bytes(precision);
numel_all=floor(fb/byte_len/numchannel);
fb=numel_all*byte_len*numchannel;
if nargin >= 3
 % the real buffer will be buffersize * numch * 2 bytes
 % (int16 = 2bytes)
 if nargin<4
     read_until=numel_all;
 end
 buffersize = 4096;
 % get file size, and calculate the number of samples per channel
 if read_start<0
     read_start=read_start+numel_all-1;
     if read_until==0
         read_until=numel_all;
     end
 end
 
read_start(read_start<0)=0;
read_until=read_until+1;
read_until(read_until>numel_all)=numel_all;
read_start_byte=read_start*byte_len*numchannel;
read_until_byte=read_until*byte_len*numchannel;
numel=read_until-read_start;
%  mmm = sprintf('%d elements',numel);
%  disp(mmm);  

 eeg=zeros(numel,length(chselect));
 
% tic
%% original method
numel1=0;
%  numelm=0;
datafile = fopen(fname,'r');
state= fseek(datafile,read_start_byte,'bof');
%  while ~feof(datafile),
 while ftell(datafile)<read_until_byte && ~feof(datafile) && state==0
     len_left=read_until_byte-ftell(datafile);
     if len_left>=buffersize*numchannel*byte_len
         [data,count] = fread(datafile,[numchannel,buffersize],precision,b_skip);  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
     else
         [data,count] = fread(datafile,[numchannel,ceil(len_left/numchannel/byte_len)],precision,b_skip);  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
     end
   numelm = (count/numchannel); %numelm = count/numchannel;
   if numelm > 0
%        if(numel+numelm)>size(eeg,2)
%        pause;
%        end
     eeg(numel1+1:numel1+numelm,:) = data(chselect,:)';
     numel1 = numel1+numelm;
   end
end
% toc

%  %% vectorize reading zifang zhao
% tic
% for idx=1:length(chselect)
%     fseek(datafile,(chselect(idx)-1)*2,'bof');
%     data=fread(datafile,ceil(fileinfo(1).bytes / 2 / numchannel),'int16',2*(numchannel-1));
%     eeg(idx,:)=data;
% end
% toc

end
fclose(datafile);

function len=get_format_bytes(format)
len=2;