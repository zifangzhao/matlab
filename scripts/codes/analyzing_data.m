%%
clc
clear
load spike_19chan_0113-rat6-formalin.mat

chans = [17:20 25 26 28 29 30 32 38 53:60]; 

%%%%%%%%%%%%%%%%%%%%%%%%%% choudong

load choudong
N = length(starts);

DP_indexs = cell(1,N);
Ixys = cell(1,N);
Iyxs = cell(1,N);


for time_ind = 1:N;

    for i = 1:length(chans)
        eval(['channals{' num2str(i) '} = elec' num2str(chans(i)) '(elec' num2str(chans(i)) '>= starts(time_ind) &  elec'...
            num2str(chans(i)) '<= ends(time_ind));']); %%%% starts 和 ends 是各状态的其实时间，你需要自己输入
    end

    neurons = length(chans);
    
    DP_indexs{time_ind} = zeros(neurons);
    Ixys{time_ind} = cell(neurons);
    Iyxs{time_ind} = cell(neurons);
   
   
    for m = 1:neurons-1
        for n = m+1:neurons
            disp([ 'choudong:' num2str((n-m) + sum((neurons-1):-1:(neurons-(m-1)))) '/' num2str(sum(1:(neurons-1))) '    Processing neurons ' num2str(m) ' and ' num2str(n)]);
            tmp_spikes{1} = channals{m}-starts(time_ind);
            tmp_spikes{2} = channals{n}-starts(time_ind);
            if length(tmp_spikes{1})<=10 || length(tmp_spikes{2})<=10
                DP_indexs{time_ind}(m,n) = 0;
                Ixys{time_ind}{m,n} = [];
                Iyxs{time_ind}{m,n} = [];

                DP_index_mean{time_ind}(m,n) = 0;
                Ixy_max{time_ind}(m,n) = 0;
                Iyx_max{time_ind}(m,n) = 0;  
            else
                [DP_index Ixy Iyx] = PCMI_2chan(tmp_spikes);
                DP_indexs{time_ind}(m,n) = DP_index;
                Ixys{time_ind}{m,n} = Ixy;
                Iyxs{time_ind}{m,n} = Iyx;

                DP_index_mean{time_ind}(m,n) = (sum(Ixy) - sum(Iyx))/(sum(Ixy) + sum(Iyx));
                Ixy_max{time_ind}(m,n) = max(Ixy);
                Iyx_max{time_ind}(m,n) = max(Iyx);            
            end
            
            save result_formalin_rat6_choudong.mat
        end
    end
    
end