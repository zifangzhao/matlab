%% ICA weight analysis
function ICA_weight_analysis()
mat_files=dir('*_ICA.mat');
ica=zeros(32,32,length(mat_files));

for f_idx=1:length(mat_files)
    mo=matfile(mat_files(f_idx).name);
    chs=mo.icachansind;
    ica(1:size(mo.icaweights,1),chs,f_idx)=mo.icaweights;
end
str={mat_files(:).name};
[s_f,~] = listdlg('PromptString','Select file to be template',...
    'SelectionMode','single',...
    'ListString',str);

ica_ch=[];
good_ch=1:32;
s=0;
while ~isempty(s)
    chnleft=setdiff(good_ch,ica_ch)';
    [s,~] = listdlg('PromptString',['SEL CHNs:' num2str(ica_ch)],...
        'SelectionMode','single',...
        'ListString',num2str(chnleft));
    ica_ch=[ica_ch chnleft(s)];
end

figure();
plot_ICA(ica,ica(ica_ch,:,s_f),{mat_files(:).name})

function plot_ICA(ica,ica_temp,titlename)
n=size(ica,3);
N=ceil(n^0.5);
M=round(n^0.5);
sub_idx=1;
for idx=1:n
%     subplot(N,M,sub_idx);sub_idx=sub_idx+1;
%     imagesc(ica(:,:,1));
%     subplot(N,M,sub_idx);sub_idx=sub_idx+1;
%     imagesc(ica(:,:,idx));
    subplot(N,M,sub_idx);sub_idx=sub_idx+1;
    d=pdist2(ica_temp,(ica(:,:,idx)));
    d1=pdist2(-ica_temp,(ica(:,:,idx)));
    mask=d>d1;
    d(mask)=d1(mask);
%     imagesc(zscore(d,[],1))
    imagesc(mapminmax(d,0,1))
    title(titlename{idx},'interpreter','none');
    set(gca,'xtick',1:size(ica,2));
    set(gca,'ytick',1:size(ica,1));
    ylabel('Template');
    xlabel('Target');
end