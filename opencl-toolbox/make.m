% %%%%%%%%%%%%%%%% CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% opencl_include_dir = '\usr\include';
% opencl_lib_dir = '\usr\lib';
opencl_include_dir = 'D:\Program Files (x86)\Intel\OpenCL SDK\3.0\include';
opencl_lib_dir = 'D:\Program Files (x86)\Intel\OpenCL SDK\3.0\lib\x64';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mex('src/openclcmd.cpp', '-Iinclude', ['-I' opencl_include_dir], ...
    ['-L' opencl_lib_dir], '-lOpenCL' );
