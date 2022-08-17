% [f,p]=uigetfile('*.rhs');
p=uigetdir();
p=[p '\'];
flist=dir([p '*.rhs']);
for i=1:length(flist)
    f=flist(i).name;
    read_Intan_RHS2000_file_frank(f,p); %read intan data into RAM
    fs_raw=frequency_parameters.amplifier_sample_rate;
    fs=20000;
    data=resample(amplifier_data',fs,fs_raw);
    sav2dat([p f(1:end-4) '_amplifier.dat'],data');
end

