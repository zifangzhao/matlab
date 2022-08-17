%%startup settings for matlab(windows)
%for aero-think-pc

if ispc
    %% path setup
    function_root='I:\My Works\Matlab\function';
    addpath(function_root);
    addpath([function_root '\gpu']);
    addpath([function_root '\scripts']);
    addpath([function_root '\Buzlab']);
    addpath([function_root '\tsne']);
    addpath([function_root '\eeglab']);
    addpath(genpath([function_root '\eeglab']));
    addpath([function_root '\FMAtoolbox']);
%     addpath([function_root '\FMAToolbox\Analyses\private']);
    % addpath('D:\google drive\HD128\code');
    addpath(genpath([function_root '\FMAtoolbox']));
    addpath(genpath([function_root '\FMAtoolbox\Analyses']));
    addpath(genpath([function_root '\chronux_2_00']));
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
        %% path setup
    function_root='/media/frank/Win7/function';
    addpath(function_root);
    addpath([function_root '/tSNE']);
    addpath([function_root '/gpu']);
    addpath([function_root '/scripts']);
    addpath([function_root '/Buzlab']);
    addpath([function_root '/eeglab']);
    addpath([function_root '/FMAToolbox']);
    addpath('/media/frank/others_HDD/google drive/HD128/code');
    % addpath(genpath([function_root '\HMMall']));
end
%% randomize the initial state of all number generators
rng('shuffle');
cd(function_root)
clear all
%% plot setting
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')
set(0,'defaultFigureColormap', jet)
Browse('on');

close all
close all