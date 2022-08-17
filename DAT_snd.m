%sound player for DAT file
clear sound
[f,p]=uigetfile('*.dat');
cd(p)
filename=[p '\' f];

Nchan=32;
chans=17;
fs=1.25e3;

% Nchan=32;
% chans=17;
% fs=1250;
target_res_rate=16;
target_fs=fs*target_res_rate;
res_rate=target_res_rate*0.90;
bulk=round(0.01*fs);

AP= dsp.AudioPlayer('SampleRate',target_fs,...
        'BufferSizeSource','Property','BufferSize',256,...
    'QueueDuration',0.3,'OutputNumUnderrunSamples',true);
[a,fb]=readmulti_frank(filename,Nchan,chans,0,1);
start=round(fb/2/Nchan);
t_start=start;
tic;
nUnder=0;
bias=[];
while 1
    t_loop=toc;
    while 1
        [a,fb]=readmulti_frank(filename,Nchan,chans,start,inf);
        t_now=toc;
        if ~isempty(a)
            break;
        else
            if toc-t_loop>5;
                break;
            end
        end
        
    end
    if toc-t_loop>5
        break;
    end
    a=(a(2:end)-32768)/65536;
    if isempty(bias);
        bias=mean(a);
    end
    a=a-bias;
    
    %     step(AP,10*a);
    %     temp=resample(100*a',res_rate,1)';
    temp=100*reshape(ones(round(target_res_rate),1)*a',[],1);
%     temp=interp1(1:length(a),100*a,linspace(1,length(a),res_rate*length(a)+double(nUnder)))';
    nUnder=step(AP,temp);
    
    %     temp(end)=temp(end-1);
    if nUnder>0
%         res_rate=target_res_rate*fs/real_fs;
        AP.SampleRate=real_fs*target_res_rate;
        disp(['Underrun samples: ' num2str(nUnder) ' realtime_fs:' num2str(real_fs)]);
        
    end
    start=(fb/2/Nchan);
    real_fs=((fb/2/Nchan)-t_start)/t_now;
end
release(AP);