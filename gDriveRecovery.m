path = 'C:\Users\aeria\AppData\Local\Google\DriveFS\114067585321983800940\content_cache';
% path = 'C:\GoogleDriveRecovery\';
outputdir = 'C:\GoogleDriveRecovery\';
unzipper ='"C:\Users\aeria\AppData\Local\SourceTree\app-3.4.15\tools\7z.exe" ';
allfiles = genpath(path);
allfiles_sep = strsplit(allfiles,';');
%%
for idx=1:length(allfiles_sep)
    system([unzipper 'x -y ' allfiles_sep{idx} ' ' '"-o' outputdir '"']);
    disp(['Processing:' num2str(idx) '/' num2str(length(allfiles_sep))]); 
end