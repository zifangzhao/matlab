function [Delays,Ixys,Iyxs,DPs]=pcmi_LFP(rawdata_valid,system_fs,starts,ends,chans,order,tau,delta,stps)
% 2012-05-24 revised by Zifang Zhao added DPs ,compatible with 5-24 version of CMI_PE_tau and CMI_PE 
% 2012-5-6 revised by Zifang Zhao added input:stps 
% 2012-03-25 version by Zifang Zhao modified for LFP calculating,based on
% pcmi
% 2012-03-24 version by Zifang Zhao improved spike_min_rate calculation

N = length(starts);
% DP_indexs = cell(1,N);
% DP_index_mean = cell(1,N);
% Ixy_max=cell(1,N);
% Iyx_max=cell(1,N);
Ixys = cell(1,N);
Iyxs = cell(1,N);
Delays = cell(1,N);
channels=cell(1,length(chans));
channels_len = length(chans);
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

%% Data processing
for time_ind = 1:N;
    fprintf(2,['Trial ' num2str(time_ind) ' in processing \n']);
    starts_temp=starts(time_ind);
    ends_temp=ends(time_ind);
    
    parfor i = 1:length(chans)
        rawdata=rawdata_valid{i};
        idx_start=round(starts_temp.*system_fs);
        idx_end=round(ends_temp.*system_fs);
        if idx_start==0;
            idx_start=1;
        end
        if idx_end==0;
            idx_end=1;
        end
        if idx_start>length(rawdata)
            idx_start=length(rawdata);
        end
        if idx_end>length(rawdata)
            idx_end=length(rawdata);
        end
        
        channels{i}=rawdata(idx_start:idx_end);
        %         channels{i}=rawdata(rawdata>=starts_temp&rawdata<=ends_temp);   %从channel_spike中截取本次计算的时间段内数据
        %         eval(['channels{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2' '(days{1}.elec' num2str(chans(i)) '_unit2' '>= starts(time_ind) &  days{1}.elec'...
        %             num2str(chans(i)) '_unit2' '<= ends(time_ind));']); %%%% starts 和 ends 是各状态的其实时间，你需要自己输入
    end
    
    %     DP_indexs{time_ind} = zeros(neurons);
    %     DP_index_mean{time_ind} = zeros(neurons);
    %     Ixy_max{time_ind}=zeros(channels_len);
    %     Iyx_max{time_ind}=zeros(channels_len);
    Ixys{time_ind} = cell(channels_len);
    Iyxs{time_ind} = cell(channels_len);
    DPs{time_ind}=cell(channels_len);
    Delays{time_ind} = cell(channels_len);
    
    for m = 1:channels_len-1
        for n = m+1:channels_len
            fprintf([ 'Processing:' num2str((n-m) + sum((channels_len-1):-1:(channels_len-(m-1)))) '/' num2str(sum(1:(channels_len-1))) '    Processing channels ' num2str(m) ' and ' num2str(n)]);
            %             tmp_spikes{1} = channels{m}-starts_temp;
            %             tmp_spikes{2} = channels{n}-starts_temp;
            %             duration=(ends_temp-starts_temp)/60;
            %             min_count=spike_min_rate*duration;
            %             if length(tmp_spikes{1})<=min_count || length(tmp_spikes{2})<=min_count %如果神经元放电小于预设值spike_min，则不计算
            %                 DP_indexs{time_ind}(m,n) = 0;
            %                 Ixys{time_ind}{m,n} = [];
            %                 Iyxs{time_ind}{m,n} = [];
            
            %                 DP_index_mean{time_ind}(m,n) = 0;
            %                 Ixy_max{time_ind}(m,n) = 0;
            %                 Iyx_max{time_ind}(m,n) = 0;
            
            %                 fprintf('\n');
            %             else
            t0=toc;
            %                 [DP_index Ixy Iyx] = PCMI_2chan(tmp_spikes,bin,order,tau,delta);      %计算排列组合
            [Delay,Ixy,Iyx,DP] = CMI_PE_tau(channels{m},channels{n},system_fs,order,tau,delta,stps);
            t1=toc-t0;
            fprintf(2,[' time used ' num2str(t1) ' seconds \n']);
            %                 DP_indexs{time_ind}(m,n) = DP_index;
            Ixys{time_ind}{m,n} = Ixy;
            Iyxs{time_ind}{m,n} = Iyx;
            DPs{time_ind}{m,n} = DP;
            Delays{time_ind}{m,n}= Delay;
            
            %                 DP_index_mean{time_ind}(m,n) = (sum(Ixy) - sum(Iyx))/(sum(Ixy) + sum(Iyx));
            %                 Ixy_max{time_ind}(m,n) = max(Ixy);
            %                 Iyx_max{time_ind}(m,n) = max(Iyx);
            %             end
            
            %             multiWaitbar('Processing neurons:',((n-m) + sum((neurons-1):-1:(neurons-(m-1))))/sum(1:(neurons-1)));
        end
    end
    multiWaitbar('Trial:',time_ind/N,'color',[0.5,0.6,0.7]);
end

% close(h1);
% close(h2);
