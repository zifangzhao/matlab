%generate evt file and event.mat file base on states and stimu_on
filename=uigetfile('*.lfp');
N_state={'Wake','Drowzy','NREM','Intermediate','REM'};
sel=3;
load([filename(1:end-4) '-states.mat']); %load states
load([filename(1:end-4) '_stimulationTime.mat']) ; %load stimu_on matrix
fs=1250;
IED=unique(stimu_on(stimu_on~=0))/fs;
tim=1:length(states);
state_sel=tim(states==sel);
IED=IED(arrayfun(@(x) ~isempty(find(state_sel==x)),floor(IED)));
IED2=IED;
for idx=1:length(IED)
    IED2(IED>IED(idx)&IED<(IED(idx)+0.2))=0;
end
IED2(IED2==0)=[];
IED=IED2;
save([filename(1:end-4) '_' N_state{sel} '.mat'],'IED');

starts=IED;
mid=IED;
ends=IED;
events.time=reshape([starts ;mid;ends],1,[]);
events.description=arrayfun(@(x) ['IED start ' ],1:3*length(starts),'UniformOutput',0);
events.description(2:3:end)=arrayfun(@(x) ['IED peak ' ],1:length(ends),'UniformOutput',0);
events.description(3:3:end)=arrayfun(@(x) ['IED stop ' ],1:length(ends),'UniformOutput',0);
try
    system(['rm ' [filename(1:end-4) '.' N_state{sel} '.ied.evt']]);
end
SaveEvents([filename(1:end-4) '.' N_state{sel} '.ied.evt'],events);



%% 
uiload();
IED2=IED;
uiload();
IED=IED(:,1);
hit=0;
for idx=1:length(IED)
    if sum(IED2>(IED(idx)-0.5)&IED2<(IED(idx)+0.5));
        hit=hit+1;
    end
end
sensitivity=hit/length(IED);

hit2=0;
for idx=1:length(IED2)
    if sum(IED>(IED2(idx)-0.5)&IED<(IED2(idx)+0.5));
        hit2=hit2+1;
    end
end
specificity=hit2/length(IED2);