function [file_out,path]=nsx2dat(filename)
if nargin<1
    [filename,path]=uigetfile({'*.ns1;*.ns2;*.ns3;*.ns4;*.ns5;*.ns6','*.ns1;*.ns2;*.ns3;*.ns4;*.ns5;*.ns6|Cerebus .nsx Files'},'Open NSX file');
    filename=[path filename];
end
datafile=fopen(filename);
fseek(datafile,10,'bof');
DataOffset=fread(datafile,1,'uint32')+9;
fseek(datafile,310,'bof'); %locate byte for channel number defination
numchannel=fread(datafile,1,'uint32');
fileinfo = dir(filename);
fb=fileinfo(1).bytes;
Nsamples=(fb-DataOffset)/2/numchannel;

targetfile=[filename(1:end-3) 'dat'];
fh=fopen(targetfile,'w+');
Buffer=round(1024*1024*1/numchannel);
ptr=0;
multiWaitbar('Converting...',0);

tic;
while toc<5
    if ptr<=Nsamples
        fileinfo = dir(filename);
        fb=fileinfo(1).bytes;
        Nsamples=(fb-DataOffset)/2/numchannel;
        temp=readnsx(filename,1:numchannel,ptr,ptr+Buffer-1);
        fwrite(fh,temp','int16');
        ptr=ptr+Buffer;
        multiWaitbar('Converting...',ptr/Nsamples);
        tic
    end
end
fclose(datafile);
fclose(fh);
[~,f,e]=fileparts(targetfile);
file_out=[f e];
multiWaitbar('close all');