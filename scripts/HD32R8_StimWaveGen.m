%% waveform_generator f330
fs=1250;
duration_per_sample=1; %how many cycle of the
Sig_len=round(250); % used to control how many cycles to generator one signal loop(effect the frequency)

current_mode=5; %maximal voltage of max output
desired_current=2; %peak output voltage for the signal
current_ratio=desired_current/current_mode;
s_wave=sin(1.5*pi+linspace(0,2*pi,Sig_len)); 
disp(['Duration(one cycle):' num2str(Sig_len/fs*1000) ' ms,MaxVoltage(Each side):' num2str(desired_current) 'V'])
%DAC_precision=12;
%%
offset=65536/2;
s_wave=offset+round(mapminmax(s_wave,0,current_ratio*32768)); %12bit precision
s_waveNeg=offset-round(mapminmax(s_wave,0,current_ratio*32768)); %12bit precision

%s_wave(end)=0; %the last data has to be zero to 
cmd=cell(length(s_wave),1);

high_w='DAC0H'; %'IDA0H' for f330
low_w='DAC0L';

for idx=1:1:length(s_wave)
    s=dec2bin(s_wave(idx),16);
    L=[s(9:end)];
    H=[s(1:8),'B'];
    cmd{1+4*(idx-1)}=['MOV ' high_w ',#',H];
    cmd{2+4*(idx-1)}=['MOV ' low_w ',#',L];
    cmd{3+4*(idx-1)}=['JNB TF0,$'];
    cmd{4+4*(idx-1)}=['CLR TF0'];
end


%for DB command
cmd2=['DB '];  %for IDA0H and IDA0L
cmd3=['DB '];  %for IDA0H only
for idx=1:1:length(s_wave)
    s=dec2bin(s_wave(idx),16);
    L=[s(9:end)];
    H=[s(1:8)];
    W1=['0' dec2hex(bin2dec(L)) 'H'];
    W2=['0' dec2hex(bin2dec(H)) 'H'];
    if mod(idx,30)==0
        cmd2=[cmd2 W1 ',' W2 ' DB '];
        cmd3=[cmd3 W2 ' DB '];
    else
        cmd2=[cmd2 W1 ',' W2 ','];
        cmd3=[cmd3 W2 ','];
    end
end
cmd2=cmd2(1:end-1);

%%
%s_wave(end)=0; %the last data has to be zero to 
cmdNeg=cell(length(s_waveNeg),1);

high_w='DAC0H'; %'IDA0H' for f330
low_w='DAC0L';

for idx=1:1:length(s_waveNeg)
    s=dec2bin(s_waveNeg(idx),16);
    L=[s(9:end)];
    H=[s(1:8),'B'];
    cmdNeg{1+4*(idx-1)}=['MOV ' high_w ',#',H];
    cmdNeg{2+4*(idx-1)}=['MOV ' low_w ',#',L];
    cmdNeg{3+4*(idx-1)}=['JNB TF0,$'];
    cmdNeg{4+4*(idx-1)}=['CLR TF0'];
end


%for DB command
cmd2Neg=['DB '];  %for IDA0H and IDA0L
cmd3Neg=['DB '];  %for IDA0H only
for idx=1:1:length(s_waveNeg)
    s=dec2bin(s_waveNeg(idx),16);
    L=[s(9:end)];
    H=[s(1:8)];
    W1=['0' dec2hex(bin2dec(L)) 'H'];
    W2=['0' dec2hex(bin2dec(H)) 'H'];
    if mod(idx,30)==0
        cmd2Neg=[cmd2Neg W1 ',' W2 ' DB ']; %Full word precision version
        cmd3Neg=[cmd3Neg W2 ' DB ']; % High byte only version
    else
        cmd2Neg=[cmd2Neg W1 ',' W2 ','];
        cmd3Neg=[cmd3Neg W2 ','];
    end
end
cmd2Neg=cmd2Neg(1:end-1);


%PARAMS
FS=100; %100POINTS
CLK=24.5E6/12;
TMR=round(CLK/FS*1.0092);
T2_TMR=dec2hex(65535-TMR)
