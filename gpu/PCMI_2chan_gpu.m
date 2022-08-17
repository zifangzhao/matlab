function [DP_index Ixy Iyx] = PCMI_2chan_gpu(spikes,bin,order,tau,delta)

% inputs:
%     spikes: cell matrix of spike trains, neurons*1 cell, s;
%     bin   : the time window for discritizing spike trains,default is 0.001s;
%     order : data points within a motif, default is 2;
%     tau   : the number of data points between the adjacent two points of the motif, default is 1;
%     delta : delay time in conditional mutual information, not less than order, larger than the maximum delay, default is order:100;

if nargin < 2
    bin = 0.001;
end

if nargin < 3
    order = 2;
end

if nargin < 4
    tau = 1;
end

if nargin < 5
    delta = order:100;
end
% tic
spikes_counts = spikes2count(spikes,bin);
% toc
x = spikes_counts(1,:);
y = spikes_counts(2,:);
[~,Ixy,Iyx] = CMI_PE_tau_gpu(x,y,order,tau,delta);
% toc
idx_max = findmax_vec(Ixy,Iyx);
DP_index = (Ixy(idx_max) - Iyx(idx_max))/(Ixy(idx_max) + Iyx(idx_max));
% toc
%         


