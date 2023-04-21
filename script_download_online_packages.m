%% prepare all matlab packages
cwd=pwd;
loc = strfind(cwd,'\');
pth = [cwd(1:loc(end)) '\matlab_packages\'];
system([' mkdir ' pth]);
cd(pth);

gits = {'https://github.com/MouseLand/Kilosort.git',...
    'https://github.com/cortex-lab/KiloSort.git',...
    'https://github.com/buzsakilab/buzcode.git',...
    'https://github.com/brendonw1/KilosortWrapper.git',...
    };
cellfun(@(x) system(['git clone ' x]),gits);
%%
names = {'eeglab','fieldtrip'};
urls={'https://sccn.ucsd.edu/eeglab/currentversion/eeglab_current.zip',...
    'https://download.fieldtriptoolbox.org/fieldtrip-20230118.zip',...
    };
locs = cellfun(@(x) strfind(x,'/'),urls,'uni',0);
locs = cellfun(@(x) x(end),locs,'uni',0);
filenames = cellfun(@(x,y) x(y+1:end),urls,locs,'uni',0);
cellfun(@(x) system(['mkdir ' x]),names);
cellfun(@(x,y) system(['curl ' x ' --output ' y]),urls,filenames);
cellfun(@(x,y) system(['tar -xvzf ' x ' -C ' y]),filenames,names);