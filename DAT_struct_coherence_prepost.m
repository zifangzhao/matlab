%% cohereogram calculation for DAT structure
function Coh=DAT_struct_coherence_prepost(DAT)
evt_time=DAT.evt_time;
fs=DAT.fs;
win=DAT.T_win(2)/fs;
%%
C=cell(length(evt_time),1);
f_coh=@(x,y) MTCoherogram(x,y,'frequency',fs,'window',win,'overlap',1);
Bandnames={'custom','delta','theta','alpha','beta','lowGamma','highGamma','ripples'};
t_ruler=[-win*fs:win*fs]';
data=DAT.data{1};
lfp1=[t_ruler(1:win*fs+1) data(1:win*fs+1,1)];
lfp2=[t_ruler(1:win*fs+1) data(1:win*fs+1,1)];
[C1,t,freq]=f_coh(lfp1,lfp2);
f_cohb=@(x,y) struct2array(CoherenceBands_frank(MTCoherogram(x,y,'frequency',fs,'window',win,'overlap',1),freq));

%%
ch_sel=1:length(DAT.chsel);
for e_idx=1:length(evt_time)
    data=DAT.data{e_idx};
    C{e_idx}=zeros(length(Bandnames),2,length(ch_sel),length(ch_sel));
    for c1=1:length(ch_sel)
        for c2=c1+1:length(ch_sel)
            lfp1=[t_ruler data(:,c1)];
            lfp2=[t_ruler data(:,c2)];
            C{e_idx}(:,:,c1,c2)=f_cohb(lfp1,lfp2)';
        end
    end
end
Coh.coherence=C;
Coh.Bandnames=Bandnames;