%%startup settings for matlab(windows)
%for buzsakilab PC

%% path setup
if ispc
    function_root='\\Ftl-recording\ftl-rec\frank\code';
    addpath(function_root);
    addpath([function_root '\gpu']);
    addpath([function_root '\scripts']);
    addpath([function_root '\Buzlab']);
    addpath([function_root '\eeglab']);
    addpath([function_root '\FMAtoolbox']);
    % addpath('D:\google drive\HD128\code');
    addpath(genpath([function_root '\FMAtoolbox']));
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
    function_root='/Ftl-recording/ftl-rec/frank/code';
    addpath(function_root);
    addpath([function_root '/gpu']);
    addpath([function_root '/scripts']);
    addpath([function_root '/Buzlab']);
    addpath([function_root '/eeglab']);
    addpath([function_root '/FMAtoolbox']);
% addpath('D:\google drive\HD128\code');
addpath(genpath([function_root '/FMAtoolbox']));
% addpath('/home/ftlproc/Dropbox/MATLAB');
% addpath(genpath(['/home/ftlproc/Dropbox/MATLAB']));
% addpath(genpath([function_root '\HMMall']));
% addpath(genpath('/home/ftlproc/Dropbox/MATLAB'));
end

clear all
%% randomize the initial state of all number generators
rng('shuffle');

%% plot setting
set(0,'defaultFigureColormap', jet)
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')

