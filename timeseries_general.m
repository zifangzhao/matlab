%time series plot
% revised by zifang zhao @ 2012-12-24 parameter selecting 
% created by zifang zhao @ 2012-10-27
uiopen('*.mat')
close all
%% 输入分组定义
def={'90'...
    '0'...
    '0'};
answer=inputdlg({'Peak locating percentage:(0-100)'...
    'Standard deviation elinmation percentage(0-100)'...
    'Sorting startpont'},'Time Series Parameters',1,def);
idx=1;
pk_p=str2double(answer{idx});idx=idx+1;
el_p=str2double(answer{idx});idx=idx+1;
analysis_stp=str2double(answer{idx});idx=idx+1;
[dataA,dataB,stp]=timeseries_gen(time_series,pk_p,el_p,analysis_stp);
% imagesc(dataA);figure(gcf);