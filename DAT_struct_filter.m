%% Data filtering for DAT struct
function [wave]=DAT_struct_filter(DAT)
cnt=1;
band_def{cnt}=[0,4];band_name{cnt}='delta';cnt=cnt+1;
band_def{cnt}=[4,8];band_name{cnt}='theta';cnt=cnt+1;
band_def{cnt}=[8,13];band_name{cnt}='alpha';cnt=cnt+1;
band_def{cnt}=[13,30];band_name{cnt}='beta';cnt=cnt+1;
% band_def{cnt}=[10,30];band_name{cnt}='spindle';cnt=cnt+1;
band_def{cnt}=[30,80];band_name{cnt}='gamma';cnt=cnt+1;
band_def{cnt}=[80 120];band_name{cnt}='epsilon';cnt=cnt+1;
band_def{cnt}=[100 250];band_name{cnt}='ripple';cnt=cnt+1;

evt_time=DAT.evt_time;
fs=DAT.fs;
win=DAT.T_win(2)/fs;

% t_ruler=[-win*fs:win*fs]';
data_fil=zeros([size(DAT.data{1}) length(band_def) length(DAT.data)]);
data_hilbert=zeros([size(DAT.data{1}) length(band_def) length(DAT.data)]);
for idx=1:length(DAT.data)
    data=DAT.data{idx};
    t_ruler=(1:size(data,1))'/fs;
    lfp=[t_ruler data];
    for b_idx=1:length(band_def)
        BP=band_def{b_idx};
        %% filtering
        temp=FilterLFP(lfp,'passband', BP,'nyquist',fs/2);
        data_fil(:,:,b_idx,idx)=temp(:,2:end);
        data_hilbert(:,:,b_idx,idx)=hilbert(temp(:,2:end));
    end
end

wave.filtered=data_fil;
wave.hilbert=data_hilbert;
wave.Bandname=band_name;
wave.BandDef=band_def;