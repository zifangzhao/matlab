function run_single_collect()
%created by zifang zhao @ 2013-2-2, based on run_npcmi_collect()
%%Input montage
[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
if((filename)==0)
    warndlg('Please select a rat_montage file!','!! Warning !!')
    return
else
    load([pathname filename],'-mat');
end
isOpen = matlabpool('size') ;
if isOpen
    matlabpool close
end
% fs=500;
%%rearrange channel
collected_data=channelrearrange(rat_montage);
collected_data=single_fixer(rat_montage,collected_data);


uisave('collected_data','collected_data')

end