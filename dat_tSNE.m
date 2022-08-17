%% script for run t-SNE on dat file
function [mappedX,tags_all,data_wave_all,bands,data_all]=dat_tSNE(ch_sel)
[files,p]=uigetfile('*ICA.dat','MultiSelect','On');
if ~iscell(files)
    files={files};
end
data_wave_all=[];
tags_all=[];
data_all=[];

for f_idx=1:length(files)
    f=files{f_idx};
    fs=1000;
    data_wave=[];
    tags=[];
    if nargin<1 %if ch_sel is not inputed check the files for it.
        try
            load([f(1:end-4) '_chsel'])
        catch
            str=inputdlg('channel define file not found, please input channels for this file','Channel list');
            ch_sel=str2num(str{1});
        end
    end
    
    
    bands=[;13 30;30 80; 80 200];
%     bandgap=10;band1=(10:bandgap:200)';bands=cat(2,band1,band1+bandgap);
    
    step=0.5;
    t_range=[0.2 5];
    t_ref=-5;
    win=[t_ref,t_ref+step];
    data=loaddata(f,ch_sel,fs,win);
    data_wave_ref=median(cell2mat(cellfun(@(x) cal_band(x,bands,fs),data,'UniformOutput',0)),1);
    
    for t_idx=1:length(t_range)
        win=[t_range(t_idx),t_range(t_idx)+step];
        data=loaddata(f,ch_sel,fs,win);
        data_wave=[data_wave; cell2mat(cellfun(@(x) cal_band(x,bands,fs),data,'UniformOutput',0))];
        if isempty(strfind(f,'ctrl'))
%             t_range(t_range==-5)=2;
            tags=[tags; (t_range(t_idx)*ones(size(data,1),1))];
        else
            t_range(t_range==t_range(1))=1;
%             t_range(t_range==-5)=2;
            tags=[tags; (t_range(t_idx)*ones(size(data,1),1))];
        end
        data_all=[data_all;data];
        % subplot(131)
        % imagesc(data_wave);
    end
    %% standerization
    %     data_wave=zscore(data_wave,[],2);
    %     data_wave=bsxfun(@rdivide,data_wave,mean(data_wave,1));
    data_wave=bsxfun(@minus,data_wave,data_wave_ref);
    data_wave=bsxfun(@rdivide,data_wave,data_wave_ref);
    %% merge
    data_wave_all=[data_wave_all; data_wave];
    tags_all=[tags_all; tags];
    
end
% f1=uigetfile('*ICA.dat');
% ch_sel1=[8 7 3 12];
% data1=loaddata(f1,ch_sel1,fs,win);
% data_wave1=cell2mat(cellfun(@(x) cal_band(x,bands,fs),data1,'UniformOutput',0));
% subplot(132)
% imagesc(data_wave1);
% subplot(133)
% data_wave_all=[data_wave; data_wave1];
% imagesc(data_wave_all);
% tags=zeros(size(data_wave_all,1),1);
% tags(size(data_wave,1)+1:end)=1;
%% run t-SNE process
mappedX=tsne(data_wave_all,tags_all,2,min([30 size(data_wave_all,2)]),30);
figure();
densityPlot(mappedX(:,1),mappedX(:,2),tags_all,200);
hold on;
gscatter(mappedX(:,1), mappedX(:,2), tags_all);
% scatter(mappedX(:,1), mappedX(:,2),5, tags,'filled');
hold off;
axis tight

function data=loaddata(f,ch_sel,fs,win_sec)
f_evt=([f(1:end-8) '.bhv.evt']);
tp=LoadEvents(f_evt);
tp=tp.time(1:3:end);
win=win_sec*fs;
data=arrayfun(@(t) readmulti_frank(f,33,ch_sel,t+win(1),t+win(2)),round(tp*fs),'Uniformoutput',0);


function data_pwr=cal_band(data,bands,fs)
data_pwr=ones(size(bands,1),size(data,2));
flist=min(min(bands)):max(max(bands));
bidx=arrayfun(@(x) find(flist==x),bands);
for cidx=1:size(data,2)
    p=abs(awt_freqlist(data(:,cidx),fs,flist,'Gabor'));
    data_pwr(:,cidx)=arrayfun(@(x) median(median(p(:,bidx(x,1):bidx(x,2)))),1:size(bands,1));
end
%% standerization
% data_pwr=zscore(data_pwr,1);

data_pwr=reshape(data_pwr,1,[]);