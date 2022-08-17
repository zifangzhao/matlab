% matlabpool
% [fn,pn]=uigetfile('.mat','Please select the EEG matfile.');
function Power=freq_plot
matfile=dir('*.mat');
LP=[1,4,8,13,30];
HS=[4,8,13,30,50];

rawdata=load([pwd '\' matfile(1).name]);
fname=fieldnames(rawdata);
idx=find(~cellfun(@isempty,(strfind(fname,'smp'))));
data=getfield(rawdata,fname{idx});

Power=cell(size(data,1),length(LP));
for channel=1:size(data,1);
    for f_idx=1:length(LP)
        Power{channel,f_idx}=zeros(length(matfile),1);
    end
end
for file_idx=1:length(matfile)
    
    rawdata=load([pwd '\' matfile(file_idx).name]);
    fname=fieldnames(rawdata);
    idx=find(~cellfun(@isempty,(strfind(fname,'smp'))));
    data=getfield(rawdata,fname{idx});

    for channel=1:size(data,1);
        [SP_data,f]=pwelch(data(channel,:),256,128,256,250);
        for f_idx=1:length(LP)
            Power{channel,f_idx}(file_idx)=sum(SP_data(LP(f_idx)<=f&f<HS(f_idx)));
        end
    end

end
% matlabpool close