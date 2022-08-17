%% cohereogram calculation for DAT structure
function Coh=DAT_struct_coherence_varlen(DAT)
evt_time=DAT.evt_time;
fs=DAT.fs;

%%
C=cell(length(evt_time),1);
Bandnames={'custom','delta','theta','spindles','lowGamma','highGamma','ripples'};

%%
ch_sel=1:length(DAT.chsel);
for e_idx=1:length(evt_time)
    data=DAT.data{e_idx};
    C{e_idx}=zeros(length(Bandnames),1,length(ch_sel),length(ch_sel));
    t_ruler=(1:size(data,1))'/fs;
    for c1=1:length(ch_sel)
        for c2=c1+1:length(ch_sel)
            lfp1=[t_ruler data(:,c1)];
            lfp2=[t_ruler data(:,c2)];
            [coherogram,~,freq]=MTCoherogram(lfp1,lfp2,'frequency',fs,'window',size(data,1)/fs,'overlap',1);
            C{e_idx}(:,:,c1,c2)=struct2array(CoherenceBands(coherogram,freq));
        end
    end
end
Coh.coherence=C;
Coh.Bandnames=Bandnames;