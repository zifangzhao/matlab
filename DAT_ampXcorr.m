%DAT ampcorr
[f_mul,p]=uigetfile('*.dat','MultiSelect','on');
Nch=33;
fs=1000;
flist=1:1:200;
t_win=2;
if ~iscell(f_mul)
    x=f_mul;
    f_mul=cell(1);
    f_mul{1}=x;
end
cd(p);
% [fevt,pevt]=uigetfile('*.evt');
multiWaitbar('Progress',0);
for f_idx=1:length(f_mul)
    f=f_mul{f_idx};
    pevt=p;
    try
        fevt=[f(1:end-8) '.bhv.evt'];
        tp=LoadEvents([pevt fevt]);
    catch
        fevt=[f(1:end-8) '.stm.evt'];
        tp=LoadEvents([pevt fevt]);
    end
    
    tlist=tp.time(1:3:end);
    try
        load([f(1:end-4) '_chsel.mat'])
        chlist=ch_sel;
        %%
    catch
        chlist=[6 1 3 5];%[8 12 24 31];%
    end
    hf=figure('Name',f);
    M=length(chlist);
    
    idxall=zeros(0,2);
    for idxA=1:length(chlist)
        for idxB=idxA:length(chlist)
            idxall(end+1,:)=[idxA,idxB];
        end
    end
    c_all=cell(length(idxall),2);
    for idx=1:size(idxall,1)
        idxA=idxall(idx,1);
        idxB=idxall(idx,2);
        A=chlist(idxA);
        B=chlist(idxB);
        c=zeros(length(flist),length(flist),length(tlist));
        c1=zeros(length(flist),length(flist),length(tlist));
        for tidx=1:length(tlist)
            tx=tlist(tidx);
            data=readmulti_frank([p f],Nch,[A B],tx*fs,tx*fs+fs*t_win);
            data_pre=readmulti_frank([p f],Nch,[A B],(tx-t_win)*fs,tx*fs);
            cpre=amp_correlation(data(:,1),data(:,2),fs,flist,0);
            cpost=amp_correlation(data_pre(:,1),data_pre(:,2),fs,flist,0);
            %             c(:,:,tidx)=((c1-c2)./c2);
            c(:,:,tidx)=cpost;
            c1(:,:,tidx)=cpre;
            %             c(:,:,tidx)=log10(c1);
        end
        c_all(idx,:)={c,c1};
    end
    cnt=1;
    for idxA=1:length(chlist)
        for idxB=idxA:length(chlist)
            A=chlist(idxA);
            B=chlist(idxB);
            subplot(M,M,M*(idxA-1)+idxB);
            imagesc(flist,flist,(median(c_all{cnt,1},3)));axis xy;xlabel(['CH' num2str(A) ' Frequency/Hz']);ylabel(['CH' num2str(B) ' Frequency/Hz'])
            cnt=cnt+1;
        end
    end
    saveas(hf,[f(1:end-4) '_AmpXcorr.fig']);
    saveas(hf,[f(1:end-4) '_AmpXcorr.jpg'])
    save([f(1:end-4) '_AmpXcorr'],'f','c_all','chlist','tlist','fevt','flist','fs','Nch','t_win');
    multiWaitbar('Progress',f_idx/length(f_mul));
end
multiWaitbar('close all');