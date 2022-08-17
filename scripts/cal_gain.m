%CODE for extracting the gain of the system
fs_mux=40e3;
fs=fs_mux/32;
convert_eff=1/65535*3.3/200*1e6;

ch_sel=21;
wn=[0.02/fs 0.2/fs;0.5/fs 1.5/fs;8/fs 12/fs;90/fs 100/fs; 900/fs 1100/fs];
G=zeros(length(wn),1);
for idx=1:size(wn,2)
    [b,a]=butter(2,wn(idx,:),'bandpass');
    data_fil=filter(b,a,data(:,ch_sel));
end