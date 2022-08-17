%DAT_sndreply
[f,p]=uigetfile('*.dat;*.lfp');
cd(p)
filename=[p '\' f];

Nchan=105;
chans=76;
fs=1250;


% Nchan=64;
% chans=54;
% fs=20e3;

% Nchan=32;
% chans=17;
% fs=1250;
target_fs=fs*10;
tic
bulk=round(1*fs);
% AP= dsp.AudioPlayer('SampleRate',fs,'QueueDuration',5);
start=0;

fb=inf;
% while start<=fb/2/Nchan/fs
%     if floor(toc-start)>1
%         start=start+1;
%         [a,fb]=readmulti_frank(filename,Nchan,chans,start*fs,(start+1)*fs);
%         a=(a-32768)/65536;
%         step(AP,a);
%     end
% end
[a,fb]=readmulti_frank(filename,Nchan,chans,0,inf);
a=(a-32768)/65536;
a=a/2;
% sound(a,fs)
sound(resample(a,target_fs,fs),target_fs)
release(AP);