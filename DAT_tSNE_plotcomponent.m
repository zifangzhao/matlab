%% dat t-sne plot components
% 
% [s,~] = listdlg('PromptString','Select band to plot',...
%     'SelectionMode','single',...
%     'ListString',{num2str(bands)});
p=uigetdir(pwd,'Select the output folder');
h=figure();
for c_idx=1:size(data_wave_all,2)
densityPlot(mappedX(:,1),mappedX(:,2),data_wave_all(:,c_idx),200);
hold on;
gscatter(mappedX(:,1), mappedX(:,2), tags);
hold off;
title(['Region: ' num2str(ceil(c_idx/size(bands,1))) ' Band: ' num2str(bands(1+mod(c_idx-1,size(bands,1)),:)) ]);
saveas(h,[p '\' num2str(c_idx) '.jpg']);
end
