%% cohereogram calculation for DAT structure
function C=DAT_struct_coherence()
evt_time=DAT.evt_time;
%%
C=cell(length(evt_time),2);
f_coh=@(x,y) MTCoherogram(x,y,'frequency',fs,'range',[0 200],'window',5);
Bandnames={'custom','theta','delta','spindles','lowGamma','highGamma','ripples'};
t_ruler=[-win*fs:win*fs]';
data=readmulti_frank([p fl],Nch,ch_sel,evt_time(1)-win*fs,evt_time(1)+win*fs);
lfp1=[t_ruler(1:win*fs+1) data(1:win*fs+1,1)];
lfp2=[t_ruler(1:win*fs+1) data(1:win*fs+1,1)];
[C1,t,f]=f_coh(lfp1,lfp2);
f_cohb=@(x,y) median(struct2array(CoherenceBands(MTCoherogram(x,y,'frequency',fs,'range',[0 200],'window',5),f)),1);
Cx=CoherenceBands(C1,f);
%%
for e_idx=1:length(evt_time)
    data=readmulti_frank([p fl],Nch,ch_sel,evt_time(e_idx)-win*fs,evt_time(e_idx)+win*fs);
    C{e_idx,1}=zeros(7,length(ch_sel),length(ch_sel));
    C{e_idx,2}=zeros(7,length(ch_sel),length(ch_sel));
    for c1=1:length(ch_sel)
        for c2=c1+1:length(ch_sel)
            lfp1=[t_ruler(1:win*fs+1) data(1:win*fs+1,c1)];
            lfp2=[t_ruler(1:win*fs+1) data(1:win*fs+1,c2)];
            C1=f_cohb(lfp1,lfp2);
            lfp3=[t_ruler(win*fs+1:end) data(win*fs+1:end,c1)];
            lfp4=[t_ruler(win*fs+1:end) data(win*fs+1:end,c2)];
            C2=f_cohb(lfp3,lfp4);
            C{e_idx,1}(:,c1,c2)=C1;
            C{e_idx,2}(:,c1,c2)=C2;
        end
    end
end
