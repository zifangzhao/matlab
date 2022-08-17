%convert all NSX file to dat file in same folder
function nsx2dat_folder(target_dir)
if nargin<1
    target_dir=uigetdir();
    cd(target_dir);
end
nsx_files=dir([target_dir '\*.ns*']);
for idx=1:length(nsx_files);
    nsx2dat([target_dir '\' nsx_files(idx).name])
end
    