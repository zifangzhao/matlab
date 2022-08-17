@echo off
rem MEXOPTS.BAT
rem
rem    Compile and link options used for building MEX-files
rem    using NVCC and the Microsoft Visual C++ compiler version 9.0.
rem
rem    Copyright 2012 The MathWorks, Inc.
rem
rem StorageVersion: 1.0
rem C++keyFileName: NVCCOPTS.BAT
rem C++keyName: nvcc
rem C++keyManufacturer: NVIDIA
rem C++keyVersion: 
rem C++keyLanguage: C++
rem C++keyLinkerName: Microsoft Visual C++ 2012
rem C++keyLinkerVersion: 11.0
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************

set MATLAB=%MATLAB%
set VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 11.0
set VCINSTALLDIR=%VSINSTALLDIR%\VC
rem In this case, LINKERDIR is being used to specify the location of the SDK
set LINKERDIR=C:\Program Files (x86)\Windows Kits\8.0
echo LINKERDIR= %LINKERDIR%
rem We assume that the CUDA toolkit is already on your path. If this is not the
rem case, you can set the environment variable MW_NVCC_PATH to the place where
rem nvcc is installed.
set PATH=%MW_NVCC_PATH%;%VCINSTALLDIR%\bin\amd64;%VCINSTALLDIR%\bin;%VCINSTALLDIR%\VCPackages;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\Common7\Tools;%LINKERDIR%\bin\x64;%LINKERDIR%\bin;%MATLAB_BIN%;%PATH%
echo PATH= %PATH%
rem Include path needs to point to a directory that includes gpu/mxGPUArray.h
set INCLUDE=%VCINSTALLDIR%\INCLUDE;%VCINSTALLDIR%\ATLMFC\INCLUDE;%LINKERDIR%\include\um;%LINKERDIR%\include\shared;%LINKERDIR%\include\winrt;%CUDA_INC_PATH%;%MATLAB%\toolbox\distcomp\gpu\extern\include;%INCLUDE%
rem extern\lib\win64 points to gpu.lib: CUDA_LIB_PATH points to cudart.lib
echo INCLUDE= %INCLUDE%
set LIB=%VCINSTALLDIR%\LIB\amd64;%VCINSTALLDIR%\ATLMFC\LIB\amd64;%LINKERDIR%\lib\win8\um\x64;%CUDA_LIB_PATH%;%MATLAB%\extern\lib\win64;%LIB%
echo LIB= %LIB%
echo LINKERDIR=%LINKERDIR%
echo CUDA_LIB_PATH= %CUDA_LIB_PATH%
set MW_TARGET_ARCH=win64

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=nvcc
set COMPFLAGS=-gencode=arch=compute_13,code=sm_13 -gencode=arch=compute_20,code=sm_20 -gencode=arch=compute_35,code=\"sm_35,compute_35\" -c --compiler-options=/GR,/W3,/EHs,/D_CRT_SECURE_NO_DEPRECATE,/D_SCL_SECURE_NO_DEPRECATE,/D_SECURE_SCL=0,/DMATLAB_MEX_FILE,/nologo,/MD -Xcompiler "/wd 4819"
set OPTIMFLAGS=--compiler-options=/O2,/Oy-,/DNDEBUG
set DEBUGFLAGS=--compiler-options=/Z7

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
rem Link with the standard mex libraries and gpu.lib.
set LIBLOC=%MATLAB%\extern\lib\win64\microsoft
set LINKER=link
set LINKFLAGS=/dll /export:%ENTRYPOINT% /LIBPATH:"%LIBLOC%" libmx.lib libmex.lib libmat.lib gpu.lib cudart.lib /MACHINE:X64 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /manifest /incremental:NO /implib:"%LIB_NAME%.x" /MAP:"%OUTDIR%%MEX_NAME%%MEX_EXT%.map" 
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug /PDB:"%OUTDIR%%MEX_NAME%%MEX_EXT%.pdb"
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%%MEX_EXT%"
set RSP_FILE_INDICATOR=@

echo LIBLOC= %LIBLOC%
rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=rc /fo "%OUTDIR%mexversion.res"
set RC_LINKER=

set POSTLINK_CMDS=del "%LIB_NAME%.x" "%LIB_NAME%.exp"
set POSTLINK_CMDS1=mt -outputresource:"%OUTDIR%%MEX_NAME%%MEX_EXT%;2" -manifest "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS2=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS3=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.map"
