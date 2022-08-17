%script to convert Xcorr to bands
% DAT_ampXcorr reprint
%DAT ampcorr
[f_mul,p]=uigetfile('*_AmpXcorr.mat','MultiSelect','on');
cd(p);
% [fevt,pevt]=uigetfile('*.evt');
multiWaitbar('Progress',0);
c_range=[-0.2 0.2];
f_range=[0 50];
Freq_bands={[1 4],[4 8],[8,13],[13 30],[30 80],[80 200]};
Freq_idx=Freq_bands;
M=length(chlist);
for c_idx=1:length(Freq_idx)
    c_dist=abs(bsxfun(@minus,Freq_bands{c_idx},flist'));
    [~,Freq_idx{c_idx}]=min(c_dist,[],1);
end
Freq_bands_name={'D','T','A','B','G','H'};
Location_name={'ACC','OFC','S1','PAG'};
if ~iscell(f_mul)
    f_temp=f_mul;
    f_mul=cell(1);
    f_mul{1}=f_temp;
end
for f_idx=1:length(f_mul)
    load(f_mul{f_idx});
    cnt=1;
    for idxA=1:length(chlist)
        for idxB=idxA:length(chlist)
            A=chlist(idxA);
            B=chlist(idxB);
            subplot(M,M,M*(idxA-1)+idxB);
            cc=c_all{cnt};
            cc(isnan(cc))=0;
%             cc_bands=zeros(length(Freq_bands),length(Freq_bands));
            [xx,yy]=meshgrid(1:length(Freq_bands),1:length(Freq_bands));
            cc_bands=arrayfun(@(x,y) median(median(cc(Freq_idx{x}(1):Freq_idx{x}(2),Freq_idx{y}(1):Freq_idx{y}(2)))),xx,yy);
            hf=imagesc(1:length(Freq_bands),1:length(Freq_bands),cc_bands);
            set(gca,'XTickLabel',Freq_bands_name,'YTickLabel',Freq_bands_name);
            set(gca,'Xtick',1:length(Freq_bands),'Ytick',1:length(Freq_bands));
            title(['AmpXcorr ' Location_name{idxA} ' To ' Location_name{idxB}]);
            axis xy;
            caxis(c_range)
            cnt=cnt+1;
        end
    end
    saveas(hf,[f(1:end-4) '_AmpXcorr_bands.fig']);
    saveas(hf,[f(1:end-4) '_AmpXcorr_bands.jpg'])
    
    multiWaitbar('Progress',f_idx/length(f_mul));
end
multiWaitbar('close all');