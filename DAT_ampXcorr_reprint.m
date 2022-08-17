% DAT_ampXcorr reprint
%DAT ampcorr
[f_mul,p]=uigetfile('*_AmpXcorr.mat','MultiSelect','on');
cd(p);
% [fevt,pevt]=uigetfile('*.evt');
multiWaitbar('Progress',0);
c_range=[-0.2 0.2];
f_range=[0 50];
M=length(chlist);
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
            hf=imagesc(flist,flist,(median(cc,3)));
            axis xy;
            xlabel(['CH' num2str(A) ' Frequency/Hz']);
            ylabel(['CH' num2str(B) ' Frequency/Hz'])
            caxis(c_range)
            xlim(f_range)
            ylim(f_range)
            cnt=cnt+1;
        end
    end
    saveas(hf,[f(1:end-4) '_AmpXcorr.fig']);
    saveas(hf,[f(1:end-4) '_AmpXcorr.jpg'])
    
    multiWaitbar('Progress',f_idx/length(f_mul));
end
multiWaitbar('close all');