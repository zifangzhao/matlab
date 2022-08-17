%%2012-3-25 improved with sparse matrix
function [DP_indexs,DP_index_mean,Ixy_max,Iyx_max,Ixys,Iyxs]=pcmi(rawdata_valid,starts,ends,chans,spike_min,bin,order,tau,delta)
N = length(starts);
DP_indexs = cell(1,N);
DP_index_mean = cell(1,N);
Ixy_max=cell(1,N);
Iyx_max=cell(1,N);
Ixys = cell(1,N);
Iyxs = cell(1,N);
channels=cell(1,length(chans));
neurons = length(chans);
%% check and start ticking
try
    toc;
catch err
    disp(['There is an Error, Cupcake! ' err.message]);
    tic;
end
multiWaitbar('Trial:',0,'color',[0.5,0.6,0.7]);
% multiWaitbar('Processing neurons:',0);
% h1=waitbar(0,'Over all progress of one bhv');
% h2=waitbar(0,'Processing neurons...');
% pos_w1=get(h1,'position');
% pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];

%% neuron processing
for time_ind = 1:N;
    fprintf(2,['Trial ' num2str(time_ind) ' in processing \n']);
    starts_temp=starts(time_ind);
    ends_temp=ends(time_ind);
    parfor i = 1:length(chans)
        channel_spike=rawdata_valid{i};
        channels{i}=channel_spike(channel_spike>=starts_temp&channel_spike<=ends_temp);   %从channel_spike中截取本次计算的时间段内数据
        %         eval(['channels{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2' '(days{1}.elec' num2str(chans(i)) '_unit2' '>= starts(time_ind) &  days{1}.elec'...
        %             num2str(chans(i)) '_unit2' '<= ends(time_ind));']); %%%% starts 和 ends 是各状态的其实时间，你需要自己输入
    end
    
    DP_indexs{time_ind} = zeros(neurons);
    DP_index_mean{time_ind} = zeros(neurons);
    Ixy_max{time_ind}=zeros(neurons);
    Iyx_max{time_ind}=zeros(neurons);
    Ixys{time_ind} = cell(neurons);
    Iyxs{time_ind} = cell(neurons);
    
    
    for m = 1:neurons-1
        for n = m+1:neurons   
            fprintf([ 'Processing:' num2str((n-m) + sum((neurons-1):-1:(neurons-(m-1)))) '/' num2str(sum(1:(neurons-1))) '    Processing neurons ' num2str(m) ' and ' num2str(n)]);
            tmp_spikes{1} = sparse(channels{m}-starts_temp);%2012-3-25
            tmp_spikes{2} = sparse(channels{n}-starts_temp);%2012-3-25
%             tmp_spikes=sparse(tmp_spikes);   %2012-3-25
            if length(tmp_spikes{1})<=spike_min || length(tmp_spikes{2})<=spike_min %如果神经元放电小于预设值spike_min，则不计算
                DP_indexs{time_ind}(m,n) = 0;
                Ixys{time_ind}{m,n} = [];
                Iyxs{time_ind}{m,n} = [];
                
                DP_index_mean{time_ind}(m,n) = 0;
                Ixy_max{time_ind}(m,n) = 0;
                Iyx_max{time_ind}(m,n) = 0;
                
                fprintf('\n');
            else
                t0=toc;
                [DP_index Ixy Iyx] = PCMI_2chan(tmp_spikes,bin,order,tau,delta);      %计算排列组合
                t1=toc-t0;
                fprintf(2,[' time used ' num2str(t1) ' seconds \n']);
                DP_indexs{time_ind}(m,n) = DP_index;
                Ixys{time_ind}{m,n} = Ixy;
                Iyxs{time_ind}{m,n} = Iyx;
                
                
                DP_index_mean{time_ind}(m,n) = (sum(Ixy) - sum(Iyx))/(sum(Ixy) + sum(Iyx));
                Ixy_max{time_ind}(m,n) = max(Ixy);
                Iyx_max{time_ind}(m,n) = max(Iyx);
            end
            
%             multiWaitbar('Processing neurons:',((n-m) + sum((neurons-1):-1:(neurons-(m-1))))/sum(1:(neurons-1)));
        end
    end
    multiWaitbar('Trial:',time_ind/N,'color',[0.5,0.6,0.7]);
end

% close(h1);
% close(h2);
