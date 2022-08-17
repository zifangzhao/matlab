%% general FFT data rearrange into single rat single mat file
%% by Xuezhu Li 2012-4-13
function laserFFT_rearrange(ratnum)

%% rearrage ctrl MAT-files
matfile=dir('*_ctrl_*pcmi*.mat');
FFTdata_ctrl_post=[];
FFTdata_ctrl_pre=[];
channums_pre=[];
channums_post=[];
for i=1:length(matfile)
    FFTpower{i}=load(matfile(i).name);
    eval(['FFTdata{i}=FFTpower{i}.' cell2mat(fieldnames(FFTpower{i})) ';']);
    attr{i}=matfile(i).name(end-7:end-4);
    if attr{i}=='post'
    FFTdata_ctrl_post=[FFTdata_ctrl_post FFTdata{i}];
    channums_post=[channums_post FFTdata{i}(:,1)];
    else 
        FFTdata_ctrl_pre=[FFTdata_ctrl_pre FFTdata{i}];
        channums_pre=[channums_pre FFTdata{i}(:,1)];
    end
end
if isequal(channums_post(:,1),channums_post(:,2),channums_post(:,3))==1
    FFT_ctrl_post.delta=[channums_post(:,1) FFTdata_ctrl_post(:,[2 8 14])./100000000];
    FFT_ctrl_post.theta=[channums_post(:,1) FFTdata_ctrl_post(:,[3 9 15])./100000000];
    FFT_ctrl_post.alpha=[channums_post(:,1) FFTdata_ctrl_post(:,[4 10 16])./100000000];
    FFT_ctrl_post.beta= [channums_post(:,1) FFTdata_ctrl_post(:,[5 11 17])./100000000];
    FFT_ctrl_post.gamma=[channums_post(:,1) FFTdata_ctrl_post(:,[6 12 18])./100000000];
end
if isequal(channums_pre(:,1),channums_pre(:,2),channums_pre(:,3))==1
    FFT_ctrl_pre.delta=[channums_pre(:,1) FFTdata_ctrl_pre(:,[2 8 14])./100000000];
    FFT_ctrl_pre.theta=[channums_pre(:,1) FFTdata_ctrl_pre(:,[3 9 15])./100000000];
    FFT_ctrl_pre.alpha=[channums_pre(:,1) FFTdata_ctrl_pre(:,[4 10 16])./100000000];
    FFT_ctrl_pre.beta= [channums_pre(:,1) FFTdata_ctrl_pre(:,[5 11 17])./100000000];
    FFT_ctrl_pre.gamma=[channums_pre(:,1) FFTdata_ctrl_pre(:,[6 12 18])./100000000];
end    
clear matfile;

%% rearrage pain MAT-files
matfile=dir('*_pain_*pcmi*.mat');
FFTdata_pain_post=[];
FFTdata_pain_pre=[];
channums_pre=[];
channums_post=[];
for i=1:length(matfile)
    FFTpower{i}=load(matfile(i).name);
    eval(['FFTdata{i}=FFTpower{i}.' cell2mat(fieldnames(FFTpower{i})) ';']);
    attr{i}=matfile(i).name(end-7:end-4);
    if attr{i}=='post'
    FFTdata_pain_post=[FFTdata_pain_post FFTdata{i}];
    channums_post=[channums_post FFTdata{i}(:,1)];
    else 
        FFTdata_pain_pre=[FFTdata_pain_pre FFTdata{i}];
        channums_pre=[channums_pre FFTdata{i}(:,1)];
    end
end
if isequal(channums_post(:,1),channums_post(:,2),channums_post(:,3),channums_post(:,4))==1
    FFT_pain_post.delta=[channums_post(:,1) FFTdata_pain_post(:,[2 8 14 20])./100000000];
    FFT_pain_post.theta=[channums_post(:,1) FFTdata_pain_post(:,[3 9 15 21])./100000000];
    FFT_pain_post.alpha=[channums_post(:,1) FFTdata_pain_post(:,[4 10 16 22])./100000000];
    FFT_pain_post.beta= [channums_post(:,1) FFTdata_pain_post(:,[5 11 17 23])./100000000];
    FFT_pain_post.gamma=[channums_post(:,1) FFTdata_pain_post(:,[6 12 18 24])./100000000];
else
end
if isequal(channums_pre(:,1),channums_pre(:,2),channums_pre(:,3),channums_pre(:,4))==1
    FFT_pain_pre.delta=[channums_pre(:,1) FFTdata_pain_pre(:,[2 8 14 20])./100000000];
    FFT_pain_pre.theta=[channums_pre(:,1) FFTdata_pain_pre(:,[3 9 15 21])./100000000];
    FFT_pain_pre.alpha=[channums_pre(:,1) FFTdata_pain_pre(:,[4 10 16 22])./100000000];
    FFT_pain_pre.beta= [channums_pre(:,1) FFTdata_pain_pre(:,[5 11 17 23])./100000000];
    FFT_pain_pre.gamma=[channums_pre(:,1) FFTdata_pain_pre(:,[6 12 18 24])./100000000];
else
end    
% clear matfile;
save(ratnum, 'FFT_ctrl_pre','FFT_ctrl_post','FFT_pain_pre','FFT_pain_post');
end