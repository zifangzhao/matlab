%% general  PCMI for formalin
function FFTpower=general_for_FFT_gravity_baseline(time_range)
% %% load 行为xls (including starts,ends)
% bhvfile=dir('*.xls');
% newData = importdata(bhvfile.name);
% clear('bhvfile');
%% load MAT-files
system_fs=1000;
matfile=dir('*001.mat');
days=cell(1,length(matfile));
for i=1:length(matfile)
    days{i}=load(matfile(i).name);
end
%% channel picking
nameall=fieldnames(days{i});
for i=1:length(nameall)
    namelength(i,1)=length(nameall{i});
end
LFPloc=find((namelength<=6)&(namelength>=5));
LFPname=nameall(LFPloc);
%% data_reorganize
for i=1:length(LFPname)
eval(['rawdata{1}.' LFPname{i} '=days{1}.' LFPname{i} ';']);
LFPdata{i}.data=eval(['rawdata{1}.' LFPname{i}]);
LFPdata{i}.name=LFPname{i};
end

%% 分不同行为、3个时相进行PCMI计算
phas_size=size(time_range);
% bhv_name=fieldnames(newData);
% datasheet_size=size(fieldnames(newData));

for phas=1:phas_size(1);   
    %再读取开始、结束时间
    %进行FFT计算
    starts=time_range(phas,1);
    ends=time_range(phas,2);
    
    for i=1:length(LFPname)
        wordlength=length(LFPname{i});
        wordleft=wordlength-4;
        if wordleft==1
            chans(i,:)=str2num(LFPname{i}(5));
        else
            chans(i,:)=str2num(LFPname{i}(5:6));
        end
        LFPcalcu{i,:}=LFPdata{i}.data(starts*system_fs:ends*system_fs,1);        
        NFFT=system_fs;
        pf = system_fs/2*linspace(0,1,NFFT/2+1);
        fft_temp=2*abs(fft(LFPcalcu{i},NFFT));
        LFP_fft{i,:}=fft_temp(1:NFFT/2+1);
        FFTpower{phas}(i,1)=chans(i,:);
        FFTpower{phas}(i,2)=min(find(LFP_fft{i,:}==max(LFP_fft{i,:}(1:48))));
    end
    
%     
    %存储数据
%     filename=matfile(1).name;
%     fname=[filename(1:end-4) suffix{phas} '.mat'];
%     save(fname,'FFTpower');
%     clear('DP_indexs','DP_index_mean','Ixy_max','Iyx_max','Ixys','Iyxs')
end

end
