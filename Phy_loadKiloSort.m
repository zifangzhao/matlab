function rst = Phy_loadKiloSort(pth)
npy_files=dir([pth '\*.npy']);
flist = arrayfun(@(x) x.name,npy_files,'uni',0);
% flist = {'amplitudes.npy',...
% 'channel_map.npy',...
% 'channel_positions.npy',...
% 'pc_features.npy',...
% 'pc_feature_ind.npy',...
% 'similar_templates.npy',...
% 'spike_templates.npy',...
% 'spike_times.npy',...
% 'template_features.npy',...
% 'template_feature_ind.npy',...
% 'templates.npy',...
% 'templates_ind.npy',...
% 'whitening_mat.npy',...
% 'whitening_mat_inv.npy',...
% 'spike_clusters.npy',...
% };

feature_name = cellfun(@(x) strrep(x,'.npy',''),flist,'uni',0);
all_rst = cellfun(@(x) readNPY([pth '\' x]),flist,'uni',0);
rst= [];
for idx=1:length(flist)
    try
    rst=setfield(rst,feature_name{idx},all_rst{idx});
    catch
        disp(['File didn''t found:' flist{idx}]);
    end
end