%lianne's script on FMA toolbox
%% Load all the information

SetCurrentSession

% % Load LFP-data

% Parameters for LL0609 (64) // LL06014  (Left VTA moved +1/4, HC in zelfdeplek).
channel = 5; %channel that shows good ripples (detected through Neuroscope) 88 for LL
refChannel = 145; % select a channel for reference (detected through Neuroscope) 72 for LL

% ch5 en ref=145 voor 1104
% ch27 en ref =145 voor 1122

% Get LFP
lfp = GetLFP(channel); % GetLFP of channel
% filtered = FilterLFP(lfp, 'passband', [100 250]);
filtered = FilterLFP(lfp, 'passband', [100 250],'filter','fir1');

lfpVTA = GetLFP(refChannel); % get LFP of a noise reference channel
% noisechan = FilterLFP(lfpVTA,'passband', [100 250]); 
noisechan = FilterLFP(lfpVTA,'passband', [100 250],'filter','fir1'); 

% Normalize data
filtered(:,2) = filtered(:,2)- repmat(mean(filtered(:,2)), [size(filtered,1) 1]);
noisechan(:,2) = noisechan(:,2)- repmat(mean(noisechan(:,2)), [size(noisechan,1) 1]);

% % Pick a start and end time for the restricted (baseline) period in the LFP
% startT = 17*60+21;
% endT = 18*60+22;

% Extract ripples
[ripples, stdev, noise] = FindRipples(filtered, 'noise', noisechan); % (possible to add  'restrict', [startT endT])

% SaveRippleEvents ('/mnt/data/Achilles151_11042013/Ripples.rip.evt', ripples, channel) %Saves the ripple evt files (cannot overwrite!)



% % Load Spike-data (Task)

spikesAll = GetSpikes('output','full'); %calls GetSpikeTimes, 
% full shows timestamps, electrode groups and clusters.


    % % Select "Bursts"

    % selected = SelectSpikes(taskSpikesVTA(:,1), 'isi', 0.050); % selects bursts out off the
    % % cells) 
    % burstVTA = taskSpikesVTA(selected,1); % ! careful does not distinguish between cells / clusters