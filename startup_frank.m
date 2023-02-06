%%startup settings for matlab(windows)
%for buzsakilab PC
clear functions
pth=which('startup_frank.m');
function_root=fileparts(pth);
str_idx = strfind(function_root,'\');
function_root_supp = [function_root(1:str_idx(end)-1) '\buzcode'];
%% path setup
if ispc
%     function_root='C:\function';
    addpath(function_root);
    addpath([function_root '\gpu']);
    addpath([function_root '\scripts']);
    addpath([function_root '\Buzlab']);
    addpath([function_root '\tsne']);
    addpath([function_root '\eeglab']);
    addpath(genpath([function_root '\eeglab']));
    addpath([function_root '\FMAtoolbox']);
%     addpath(genpath([function_root_supp ]));
%     addpath([function_root '\TheStateEditor']);
%     addpath(genpath([function_root_supp 'externalPackages\xmltree-2.0']));
    addpath(genpath([function_root '\xmltree']));
    addpath([function_root '\MATLAB\TSobjects\'])
    addpath([function_root '\MATLAB\TSobjects\Wrappers']);
    addpath([function_root '\MATLAB\TSobjects\@tsd']);
%     addpath([function_root '\FMAToolbox\Analyses\private']);
    % addpath('D:\google drive\HD128\code');
    addpath(genpath([function_root '\FMAtoolbox']));
    addpath(genpath([function_root '\FMAtoolbox\Analyses']));
    addpath(genpath([function_root '\chronux_2_00']));
    addpath(genpath([function_root '\NPMK']));
    % addpath('\home\ftlproc\Dropbox\MATLAB');
    % addpath(genpath(['\home\ftlproc\Dropbox\MATLAB']));
    % addpath(genpath([function_root '\HMMall']));
    % addpath(genpath('\home\ftlproc\Dropbox\MATLAB'));
    %% enviorment setup
    setenv('MATLAB',matlabroot);
    setenv('MATLAB_BIN',[matlabroot '\bin']);
    CUDA_PATH=getenv('CUDA_PATH');
    setenv('MW_NVCC_PATH',[CUDA_PATH '\bin']);
    setenv('CUDA_LIB_PATH',[CUDA_PATH '\lib\x64']);
    setenv('CUDA_INC_PATH',[CUDA_PATH '\include']);
else
%     function_root='/media/router/functions/zzf';
    addpath(function_root);
    addpath([function_root '/gpu']);
    addpath([function_root '/scripts']);
    addpath([function_root '/Buzlab']);
    addpath([function_root '/tsne']);
    addpath([function_root '/eeglab']);
    addpath(genpath([function_root '/eeglab']));
    addpath([function_root '/FMAToolbox']);
%     addpath([function_root '/FMAToolbox/Analyses/private']);
    addpath(genpath([function_root '/FMAToolbox']));
    addpath(genpath([function_root '/FMAToolbox/Analyses']));
    addpath(genpath([function_root '/chronux_2_00']));

end

clear all
%% randomize the initial state of all number generators
% rng('shuffle');

%% plot setting
set(0,'defaultFigureColormap', jet)
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')
set(0, 'DefaultFigureRenderer', 'painters');
% Browse('on');
close all
