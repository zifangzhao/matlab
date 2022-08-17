function spikes_count = spikes2count(spiketimes,interval,t_start,t_end)

% spiketimes: spike trains, cell array
% interval : the time in which to count spikes, in sec
% t_start: time to begin analysis, in sec
% t_end: time to stop analysis, in sec

neurons = length(spiketimes);

for i = 1:neurons
    temp = spiketimes{i};
    temp(temp==0) = [];
    times_min(i)=min(temp);
    times_max(i)=max(temp);
end

if nargin<4
    t_end = ceil(max(times_max));
end

if nargin<3
    t_start = fix(min(times_min));
end

if nargin<2
    interval = 0.001;
end

bins = t_start:interval:t_end;

spikes_count = zeros(neurons,length(bins)-1);
%disp(['neurons=' num2str(neurons)]);
parfor i = 1:neurons
    spikes_temp = spiketimes{i};
    spikes_temp(spikes_temp==0)=[];
    spikes_count_temp = histc(spikes_temp,bins);
    spikes_count(i,:) = spikes_count_temp(1:end-1);
end


