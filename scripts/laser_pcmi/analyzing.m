%%
% clc
% clear

isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
chans = [5 9 25 27 30:32 53 54 58 60]; 

%%%%%%%%%%%%%%%%%%%%%%%%%% choudong
bhvfile=dir('*.xls');
newData1 = importdata(bhvfile.name);
b=newData1.Pain;
b=b';

starts=b(10,:);
ends=b(11,:);
% load choudong %including: starts ends


matfile=dir('*.mat');
days=cell(length(matfile));
for i=1:length(matfile)
    days{i}=load(matfile(i).name);
%     nodes{i}=days{i}.ainp1_unit32;
end
% channels_ori=cell(1,length(chans));
channels=cell(1,length(chans));
for i = 1:length(chans)
    eval(['channels_ori{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2;']);
end

N = length(starts);
DP_indexs = cell(1,N);
DP_index_mean = cell(1,N);
Ixy_max=cell(1,N);
Iyx_max=cell(1,N);
Ixys = cell(1,N);
Iyxs = cell(1,N);
for time_ind = 1:N;
    disp(['Trial ' num2str(time_ind) ' in processing']);
    parfor i = 1:length(chans)
        temp=channels_ori{i};
        channels{i}=temp(temp>=starts(time_ind)&temp<=ends(time_ind));
         %         eval(['channels{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2' '(days{1}.elec' num2str(chans(i)) '_unit2' '>= starts(time_ind) &  days{1}.elec'...
%             num2str(chans(i)) '_unit2' '<= ends(time_ind));']); %%%% starts 和 ends 是各状态的其实时间，你需要自己输入
    end

    neurons = length(chans);

    DP_indexs{time_ind} = zeros(neurons);
    DP_index_mean{time_ind} = zeros(neurons);
    Ixy_max{time_ind}=zeros(neurons);
    Iyx_max{time_ind}=zeros(neurons);
    Ixys{time_ind} = cell(neurons);
    Iyxs{time_ind} = cell(neurons);


    for m = 1:neurons-1
        for n = m+1:neurons
            disp([ 'Processing:' num2str((n-m) + sum((neurons-1):-1:(neurons-(m-1)))) '/' num2str(sum(1:(neurons-1))) '    Processing neurons ' num2str(m) ' and ' num2str(n)]);
            tmp_spikes{1} = channels{m}-starts(time_ind);
            tmp_spikes{2} = channels{n}-starts(time_ind);

            if length(tmp_spikes{1})<=10 || length(tmp_spikes{2})<=10
                DP_indexs{time_ind}(m,n) = 0;
                Ixys{time_ind}{m,n} = [];
                Iyxs{time_ind}{m,n} = [];

                DP_index_mean{time_ind}(m,n) = 0;
                Ixy_max{time_ind}(m,n) = 0;
                Iyx_max{time_ind}(m,n) = 0;  
            else
                tic
                [DP_index Ixy Iyx] = PCMI_2chan(tmp_spikes);
                toc
                DP_indexs{time_ind}(m,n) = DP_index;
                Ixys{time_ind}{m,n} = Ixy;
                Iyxs{time_ind}{m,n} = Iyx;


                DP_index_mean{time_ind}(m,n) = (sum(Ixy) - sum(Iyx))/(sum(Ixy) + sum(Iyx));
                Ixy_max{time_ind}(m,n) = max(Ixy);
                Iyx_max{time_ind}(m,n) = max(Iyx);            
            end

            
        end
    end
end
clear days;
clear temp;
save Rat4_laser_prepain_1228.mat