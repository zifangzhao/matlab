%%recording file copier
pth_from=uigetdir(pwd,'Source Folder');
pth_to=uigetdir(pwd,'Destination Folder');
cd(pth_from);
list=dir();
dir_list=arrayfun(@(x) list(x).isdir,1:length(list));
list=list(dir_list);
list(1:2)=[];
exclude_file={'amplifier.dat','.','..'};
multiWaitbar('closeall')
for idx=1:length(list);
    multiWaitbar('Dir',idx/length(list))
    cd(list(idx).name);
    list2=dir('*.*');
    file_list=arrayfun(@(x) list2(x).name,1:length(list2),'uniformOutput',0);
    skip_mat=sum(cell2mat(cellfun(@(x) strcmp(x,file_list)',exclude_file,'UniformOutput',0)),2)';
    list2=list2(~skip_mat);
    for idx2=1:length(list2)
         multiWaitbar('File',idx2/length(list2),'Color',[0.1 0.5 0.6])
         mkdir([pth_to '\' list(idx).name '\']);
        copyfile(list2(idx2).name,[pth_to '\' list(idx).name '\' list2(idx2).name]);
    end
    cd('..')
end

