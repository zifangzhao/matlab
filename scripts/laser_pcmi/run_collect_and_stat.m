%% auto script for stat analysis
%% 2012-4-21 revised by Zifang Zhao ¸ü¸Ämontageºó×º
%% 2012-4-5 by zifang zhao
%% 2012-4-4 by Zifang Zhao & Xuezhu Li

%%Input montage
[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
if((filename)==0)
    warndlg('Please select a rat_montage file!','!! Warning !!')
end
load([pathname filename],'-mat');
fs=500;
%%rearrange channel
collected_data=channelrearrange(rat_montage);
collected_data_fixed=pcmi_fixer(rat_montage,collected_data,fs);%clear('collected_data')
collected_data_fixed_Imax=pcmi_Imax_finder(rat_montage,collected_data_fixed);%clear('collected_data_fixed');
% uisave('collected_data_fixed_Imax','collected_data_fixed_Imax','-v7.3')
collected_data=data_regroup(rat_montage,collected_data_fixed_Imax);%clear('collected_data_fixed_Imax');


uisave('collected_data','collected_data_fixed_Imax_grouped')