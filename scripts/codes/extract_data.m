%%%%%%%%%%%% extract data from recording data

clc
clear
load spike_18chan_20101227-rat6-laser+.mat 
chans = [17:20 25 26 28 29 30 32 38 40 53 55:59]; 

for i = 1:length(chans)
    eval(['channals{' num2str(i) '} = elec' num2str(chans(i)) '(elec' num2str(chans(i)) '>= 2780 &  elec'...
        num2str(chans(i)) '<= 2870);  ']);
end

chan_num = length(channals);
ind = 0;
for i = 1:chan_num
    tmp = channals{i};
    if length(tmp) > 30
        ind = ind+1;
        new_channals{ind} = tmp;
        useful_chan_num(ind) = i;
    end
end