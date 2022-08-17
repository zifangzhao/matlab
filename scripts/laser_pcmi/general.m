% run original mat files for SL
%%%%%%%%%%2011-11-12 version%%%%%%%%%%
%%%%%%%%%%by Zifang Zhao%%%%%%%%%%

isOpen = matlabpool('size') ;
if isOpen< 2
    matlabpool
end
clc
clear all
close all
system_fs=1000;
Fs=100;
f1=0.05;
f2=Fs/2;
f=Fs*(0:512)/1024;

channel_num=[5:12 17:32 53:60];

% b=[0	0	1	1	0	0	1	0	0	0	1	1	0	1	0	0	1	1	1	1	1	1	1	1];%%%%%%%%%%%%%%%%%根据需要修改
bhvfile=dir('*.xls');
newData1 = importdata(bhvfile.name);
b_ctl=newData1.Sheet2;
b_ctl=b_ctl';
b_pain=newData1.Sheet3;
b_pain=b_pain';

matfile=dir('*.mat');
for i=1:length(matfile)
    days{i}=load(matfile(i).name);
    nodes{i}=days{i}.ainp1_unit32;
end

