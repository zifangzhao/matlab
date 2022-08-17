%functionalized @ 2012-6-23 by Zifang zhao
%% auto script for stat analysis
%% 2012-9-19 revised by zifang zhao ���¼���regroup,N_stat��ʹ���µ����Ϻ���
%% 2012-9-18 revised by zifang zhao ȥ��regroup,����������N_stat�У��Ż��ڴ�
%% 2012-9-13 revised by zifang zhao ������ǰ�Զ��ر�matlab pool
%% 2012-4-21 revised by Zifang Zhao ����montage��׺
%% 2012-4-5 by zifang zhao
%% 2012-4-4 by Zifang Zhao & Xuezhu Li
function run_npcmi_collect()
%%Input montage
[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
if((filename)==0)
    warndlg('Please select a rat_montage file!','!! Warning !!')
    return
else
    load([pathname filename],'-mat');
end
isOpen = ~isempty(gcp('nocreate')) ;
if isOpen
    delete(gcp)
end
% fs=500;
%%rearrange channel
collected_data=channelrearrange(rat_montage);
collected_data_fixed=Npcmi_fixer(rat_montage,collected_data);clear('collected_data')
% collected_data_fixed_Imax=pcmi_Imax_finder(rat_montage,collected_data_fixed);%clear('collected_data_fixed');
% uisave('collected_data_fixed_Imax','collected_data_fixed_Imax','-v7.3')
conti=1;
while conti==1
    grouped_data=data_regroup(rat_montage,collected_data_fixed);%clear('collected_data_fixed_Imax');
    uisave('grouped_data','collected_data_fixed_grouped')
    button=questdlg('continue re-grouping?','data_regroup','Yes','No','No');
    if strcmp(button,'No')
        conti=0;
    end
end

end