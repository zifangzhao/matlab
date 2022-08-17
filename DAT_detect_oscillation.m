function DAT_detect_oscillation(lfpfile,ch,animalstate,band,threshold,noise_ch,duration,pass_band)
if nargin<5
    threshold=[3 5];
end
if nargin<6
    noise_ch=[];
end
f_h=@(x) [900 600 3000]./x(1); %calculated based on 30 20 100 ms for gamma
if nargin<8
    switch(lower(band))
        case 'delta'
            pass_band=[1 4];
        case 'theta'
            pass_band=[4 8];
        case 'spindle'
            pass_band=[10 20];
        case 'alpha'
            pass_band=[8 13];
        case 'beta'
            pass_band=[13 30];
        case 'gamma'
            pass_band=[30 80];
        case 'lowgamma'
            pass_band=[30 50];
        case 'highgamme'
            pass_band=[80 120];
        case 'ripple'
            pass_band=[110 250];
    end
    if ~exist('duration')
        duration = f_h(pass_band);
    end
end
fbasename=lfpfile(1:end-4);
f_proc_log=[fbasename '.log'];
params_str=cellfun(@(x) ['   ' num2str(x)],{lfpfile,ch,animalstate,band,threshold,noise_ch,duration,pass_band},'uni',0);
sav2log(f_proc_log,{datestr(now),'DAT_detect_oscillation:',params_str{:}},'a+');
% [pth, fbasename, ~] = fileparts(lfpfile);
[Nch,fs,~,~,~,~]=DAT_xmlread(lfpfile);
nchannels = Nch;
gamma_channel = ch;
channelID = gamma_channel - 1;



if(~isempty(animalstate))
    state_file=[lfpfile(1:end-4) '-states.mat'];
    %     state_mat = dir('*-states*');
    load(state_file);
    StateIntervals = ConvertStatesVectorToIntervalSets(states);                 % 6 Intervalsets representing sleep states
    REM = StateIntervals{5};
    NREM = or(StateIntervals{2}, StateIntervals{3});
    WAKE = StateIntervals{1};
    % State parameter
    if strcmp(animalstate,'NREM'),
        animalstate = NREM;
    elseif strcmp(animalstate, 'REM'),
        animalstate = REM;
    else strcmp(animalstate, 'WAKE'),
        animalstate = WAKE;
    end
    
    
    lfp = LoadLfp(fbasename,nchannels,gamma_channel);
    t=Range(Restrict(lfp, animalstate), 's');
    lfp=Data(Restrict(lfp, animalstate));
else
    lfp = LoadLfp(fbasename,nchannels,gamma_channel);
    t=Range(lfp,'s');
    lfp=Data(lfp);
end
fil_sleep = FilterLFP(double([t lfp]), 'passband', pass_band);
[gamma,sd,bad] = FindRipples(fil_sleep,'thresholds', threshold, 'durations', duration);


gamma_file = strcat(fbasename, '_',num2str(gamma_channel), band);
save (gamma_file, 'gamma')
spindle_events = strcat(fbasename, '_',num2str(gamma_channel), '.', band(1:3), '.evt');
SaveRippleEvents(spindle_events,gamma,channelID);