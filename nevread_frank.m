function [eeg,fb] = nevread_frank(fname,numchannel,chselect,read_start,read_until)
% function [eeg] = function readmulti(fname,numchannel,chselect)
% 
% Reads multi-channel recording file to a matrix
% last argument is optional (if omitted, it will read all the 
% channels.
%
% From the Buzsaki lab (obtained 4/5/2010).
% revised by zifang zhao @ 2014-5-1 increased 2 input to
% control the range of file reading

b_skip=0;
precision='int16';

fileinfo = dir(fname);
if nargin == 2
 datafile = fopen(fname,'r');
 eeg = fread(datafile,[numchannel,inf],'int16');
 fclose(datafile);
 eeg = eeg';
 return
end

fb=(fileinfo(1).bytes);

if nargin >= 3

 % the real buffer will be buffersize * numch * 2 bytes
 % (short = 2bytes)
 if nargin<4
     read_until=fb;
 else
     read_until=read_until*numchannel*2;
     read_until(read_until>fb)=fb;
 end
 
 buffersize = 4096;

 % get file size, and calculate the number of samples per channel

read_start=read_start*numchannel*2+9;

 datafile = fopen(fname,'r');

if read_start<0
    read_start=fb+read_start;
%     num_pass=temp/(2*numchannel);
%     read_start=round(num_pass)*2*numchannel;
end

if read_until<=0
    read_until=fb+read_until;
%     num_pass2=temp2/(2*numchannel);
%     read_until=round(num_pass2)*2*numchannel;
end

num_pass_end=floor(read_until/2/numchannel);
 numel = floor((read_until-read_start) / 2 / numchannel);
 read_until=num_pass_end*2*numchannel;
 read_start=read_until-numel*2*numchannel;
%  mmm = sprintf('%d elements',numel);
%  disp(mmm);  

 eeg=zeros(numel,length(chselect));
 
% tic
%% original method
 numel=0;
%  numelm=0;
 fseek(datafile,read_start,'bof');
%  while ~feof(datafile),
 while ftell(datafile)<read_until && ~feof(datafile)
     len_left=read_until-ftell(datafile);
     if read_until-ftell(datafile)>buffersize*numchannel*2
         [data,count] = fread(datafile,[numchannel,buffersize],precision,b_skip);  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
     else
         [data,count] = fread(datafile,[numchannel,ceil(len_left/numchannel/2)],precision,b_skip);  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
     end
   numelm = (count/numchannel); %numelm = count/numchannel;
   if numelm > 0
%        if(numel+numelm)>size(eeg,2)
%        pause;
%        end
     eeg(numel+1:numel+numelm,:) = data(chselect,:)';
     numel = numel+numelm;
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
