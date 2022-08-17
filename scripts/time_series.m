% uiopen()
ts_cell=cell2mat(cellfun(@(x) max(x.dataA,1),time_series,'Uniformedoutput',0));