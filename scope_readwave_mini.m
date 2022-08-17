%% 读取micsig mini示波器波形文件，包括wav文件和bin文件
% file_name: 波形文件的文件名
% x：返回波形数据x轴；
% y：返回波形数据y轴；
function [x,wave] = scope_readwave_mini(file_name)
fid1 = fopen(file_name,'r');
wave = [];
x = [];
if(fid1>0)
    fseek(fid1, 16, 'bof'); 
    iWaveType = fread(fid1, 1, 'int32');
    len = fread(fid1, 1, 'int32');
    y_scale = fread(fid1, 1, 'int32');
    x_scale = fread(fid1, 1, 'int32');
    fseek(fid1, 12, 'cof');
    probeType = fread(fid1, 1, 'int32');
    probeMul = fread(fid1, 1, 'float32');
    fseek(fid1, 12, 'cof');
    fs = fread(fid1, 1, 'float64');
    fseek(fid1, 4, 'cof');
    if(iWaveType == 2)
        fseek(fid1, 12, 'cof');
        fft_f_step = fread(fid1, 1, 'float32');
        fseek(fid1, 4, 'cof');
    else
        fseek(fid1, 4*5, 'cof');
    end
    num = fread(fid1, 1, 'int32');
    fseek(fid1, 4, 'cof');
    timeScale = fread(fid1, 1, 'float64');
    vScale = fread(fid1, 1, 'float64')*probeMul/50;
    DataBits = fread(fid1, 1, 'int32');
    
    fseek(fid1, 200, 'bof'); 
    if(DataBits == 32)
        [wave,cnt] = fread(fid1, len, 'int32');
    else
        [wave,cnt] = fread(fid1, len, 'int16');
    end
    fclose(fid1)   ; 

else
    fclose(fid1)   ; 

    return;
end
x = 0:cnt-1;
if(iWaveType == 2)
    x = x*fft_f_step;
else
    x = x./fs;
end
wave = wave*vScale;




