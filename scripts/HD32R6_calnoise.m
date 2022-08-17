%%cal_noise
%% file loading
fname=uigetfile('*.dat');
t=regexpi(fname,'HD32BR(\d)','tokens');
if  str2double(t{1})==5
    Vref=3.3;
else
    Vref=2.42;
end
chnnum=32;
t=regexpi(fname,'_(\d+)K','tokens');
fs_mux=str2double(t{1}{1})*1e3;


t_start=180; %in seconds
t_end=1000;% in seconds

fs=fs_mux/chnnum;
convert_eff=1/65535*Vref/200*1e6;
data=readmulti_frank(fname,chnnum,1:chnnum,t_start*fs,t_end*fs)*convert_eff;

%%
data=data-(median(data,1)'*ones(1,size(data,1)))';

offset=([size(data,2):-1:1]'*ones(1,size(data,1)))';
% plot(data+2000*offset);

%sel_chn=22%22;
gnd_chn=22%23;

data_sel=data(:,gnd_chn);
data_sel=data_sel-mean(data_sel);
[pxx,f]=pwelch(data_sel,5*fs,fs,fs,fs);
plot(f,pxx);
xlabel('Frequency')
ylabel('Power')
save(fname(1:end-4),'pxx','f');
