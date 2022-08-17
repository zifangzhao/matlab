function eeg=readnsx(filename,chselect,read_start,read_until)
%Zifang Zhao @ 2016/10

datafile=fopen(filename);
fseek(datafile,10,'bof');
DataOffset=fread(datafile,1,'uint32')+9;
fseek(datafile,310,'bof'); %locate byte for channel number defination
numchannel=fread(datafile,1,'uint32');
fileinfo = dir(filename);
fb=fileinfo(1).bytes;
%Nsamples=floor((fb-DataOffset)/(9+2*numchannel));

% if read_start<0
%     read_until=Nsamples;
%     read_start=Nsamples-read_start;
% end
% 
% read_until(read_until>Nsamples)=Nsamples;
% read_start(read_start<0)=0;
% 
% Nacq=read_until-read_start;
% data=ones(length(chlist),Nacq);
% 
% fseek(datafile,DataOffset+read_start*(Nch*2+9)+9,'bof'); %locate begining of data packet


buffersize = 4096;
 % get file size, and calculate the number of samples per channel
read_start=read_start*numchannel*2;
read_until=read_until*numchannel*2;
read_until(read_until>fb-DataOffset)=fb-DataOffset;
if read_start<0
    read_start=fb-DataOffset+read_start;
%     num_pass=temp/(2*numchannel);
%     read_start=round(num_pass)*2*numchannel;
end

if read_until<=0
    read_until=fb-DataOffset+read_until;
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
 fseek(datafile,read_start+DataOffset,'bof');
%  while ~feof(datafile),
 while ftell(datafile)<(read_until+DataOffset) && ~feof(datafile)
     len_left=read_until-ftell(datafile)+DataOffset;
     if read_until-ftell(datafile)+DataOffset>buffersize*numchannel*2
         [data,count] = fread(datafile,[numchannel,buffersize],'int16');  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
     else
         [data,count] = fread(datafile,[numchannel,ceil(len_left/numchannel/2)],'int16');  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
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

fclose(datafile);
