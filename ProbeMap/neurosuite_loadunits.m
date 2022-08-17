function [units,waveform]=neurosuite_loadunits(f,spike_window)
% load cluster and spike files from NeuroSuite data
% Usage: 
% This script will automatic load all spike information from the selected cluster file(*.clu)
% input: 
%   filename of the cluster file(*.clu), could leave empty for GUI file selection window
%   spike_window defines the spike data length around spike time. Default=30
% output: 
%   units is a structure contains spike information
%       .spiketime contains spiketime in second for all the clusters
%       .clusterlist contains a list of cluster number saved in .clu file
%   waveform is a cell contains all the spike waveforms
%       each cell contains a 3D matrix (time-channel-spikeIndex)

% To use this function, here are some examples 
% 1. spike time load:  units=neurosuite_loadunits('data.clu.1');
% 2. spike waveform load. [units,waveform]=neurosuite_loadunits('data.clu.1');
%       for example, if you want to get average waveform of unit 2 type:
%       averaged_wave=median(waveform{units.clusterlist==2},3);

% created by Zifang Zhao, 2019/8

if nargin<1
    [f,p]=uigetfile({'*.clu.*','*.clu.*|Select cluster file'});
    f=[p f];
else
    p=[];
end

if nargin <2
    spike_window=16;
end

loc=strfind(f,'.clu');
try
    [Nch,fs,Nsamples,~,~,~]=DAT_xmlread_inline([f(1:loc) 'dat']);
catch
    msgbox('XML file not found in the folder, Using 20KHz sampling rate as default for .dat file')
    fs=20e3;
end

clu=importdata([f]);  %load cluster file
spk_time=importdata([strrep([f],'.clu.','.res.')]); %load spike time
spk_Nclu=clu(1);
spk_clu=clu(2:end);  %cluster index for each spike
clu_list=unique(spk_clu);
clu_list(ismember(clu_list,[0,1]))=[]; %only load units other than Noise and MUA
idx_rmv=(spk_time<(spike_window-1))|(spk_time>(Nsamples-spike_window-1));
spk_time(idx_rmv)=[];
spk_clu(idx_rmv)=[];
units.spiketime=arrayfun(@(x) spk_time(spk_clu==x),clu_list,'UniformOutput',0);
units.clusterlist=clu_list;
if nargout>1
    waveform=cell(length(clu_list),1);
    for idx=1:length(waveform)
        temp=arrayfun(@(t) readmulti_inline([f(1:loc) 'fil'],Nch,1:Nch,t-spike_window,t+spike_window-1),units.spiketime{idx},'UniformOutput',0);
        waveform{idx}=cat(3,temp{:});
    end
end
units.spiketime=cellfun(@(x) x/fs,units.spiketime,'uniformOutput',0);

function [Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread_inline(f_base)
% read DAT xml for neurosuite
% input: filename for .dat file
% create by Zifang Zhao 2018.5
[p,f,e]=fileparts(f_base);
%% read xml param
loc_dot=strfind(f_base,'.');
f_xml=[f_base(1:loc_dot(end)) 'xml'];
ff=dir(f_xml);
time_bin=[];
if isempty(ff)
    Nch=[];
    fs=[];
    Nsamples=[];
    ch_sel=[];
    good_ch=[];
    
else
    t_xml=fileread(f_xml);
    Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
    Nch=str2num(Nch_str{1});
    fileinfo = dir([f_base]);
    fb=fileinfo(1).bytes;
    Nsamples=fb/2/Nch;
    
    fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
    fs=str2num(fs_str{1});
    
    good_ch=sort(cellfun(@str2num,(regexpi(t_xml,'(?<=<channel skip="0">)\d+(?=<)','match'))))+1;
    
    if strcmp(e,'.lfp')
        fs=1250;
    end
    
    if nargout>3
        f_ch=[f_base(1:end-4) '_chsel.mat'];
        fc=dir(f_ch);
        if isempty(fc)
            ch_sel=[];
        else
            load(f_ch);
        end
    end
    if nargout>5
        f_tp=[f_base(1:end-4) '_timeselect.mat'];
        fc=dir(f_tp);
        if isempty(fc)
            time_bin=[];
%             uiopen('*_timeselect.mat');
        else
            load(f_tp);
        end
    end
    
end

function [eeg,fb] = readmulti_inline(fname,numchannel,chselect,read_start,read_until,precision,b_skip)
% eeg is output, fb is size of file in bytes
% Reads multi-channel recording file to a matrix
% last argument is optional (if omitted, it will read all the 
% channels.
%
% From the Buzsaki lab (obtained 4/5/2010).
% revised by zifang zhao @ 2014-5-1 increased 2 input to
% control the range of file reading

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
numel_all=floor(fb/2/numchannel);
fb=numel_all*2*numchannel;
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
read_start_byte=read_start*2*numchannel;
read_until_byte=read_until*2*numchannel;
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
     if len_left>=buffersize*numchannel*2
         [data,count] = fread(datafile,[numchannel,buffersize],precision,b_skip);  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
     else
         [data,count] = fread(datafile,[numchannel,ceil(len_left/numchannel/2)],precision,b_skip);  %can be improved,vectorize,arrayfun,multi-threading, zifangzhao@4.24
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
