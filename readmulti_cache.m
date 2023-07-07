function  [eeg,fb,temp_file] = readmulti_cache(fname,numchannel,chselect,read_start,read_until,precision,b_skip)
temp_dir ='D:\';
temp_file = [temp_dir fname(4:end)];
[pth,file]=fileparts(temp_file);

orig_file = dir(fname);
target_file = dir(temp_file);
f_copy = 1;
if(~isempty(target_file))
    f_copy = 0;
    if(target_file(1).bytes~=orig_file(1).bytes)
        delete(target_file)
        f_copy=1;
    end
end
if(f_copy==1)
    mkdir(pth)
    disp(['Copying file:' temp_file])
    copyfile(fname,pth)
end
if nargin<6 %precision and skip
    precision='int16';
end
if nargin<7 %skip
    b_skip=0;
end
[eeg,fb] = readmulti_frank(temp_file,numchannel,chselect,read_start,read_until,precision,b_skip);