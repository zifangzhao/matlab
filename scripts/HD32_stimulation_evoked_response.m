%stimulate evoked response
[fname,pth]=uigetfile('*.dat');
cd(pth);
fs=1250;
ttp=[-1 2];
Nchan=32;
stimu_filename=[fname(1:end-10) '_stimulationTime.mat'];
idx_to_del=[];
if ~isempty(dir(stimu_filename))
    load(stimu_filename);
    waveforms=ones(diff(ttp)*fs,Nchan,size(stimu_on,1));
    for idx=1:size(stimu_on,1)
        tp=stimu_on(idx,:);
        tp=tp(tp~=0);
        tp=tp(1);
        data=readmulti_frank(fname,Nchan,1:Nchan,tp+fs*ttp(1),tp+fs*ttp(2))*0.195;
        if size(data)==[diff(ttp)*fs,Nchan];
            waveforms(:,:,idx)=data;
        else
            idx_to_del=[idx_to_del idx];
        end
    end
    waveforms(:,:,idx_to_del)=[];
else
    msgbox('Stimulation time record not found')
end

%% display all plots
figure(1)
tim=linspace(-1,2,fs*3);
for idx=1:Nchan
    subplot(8,4,idx);
    shadedErrorBar(tim,squeeze(waveforms(:,idx,:))',{@median,@ste},{'b','markerfacecolor','r'});
    axis tight
end
figure(2)
for idx=1:Nchan
    subplot(8,4,idx);
    imagesc(tim,1:size(waveforms,3),squeeze(waveforms(:,idx,:))');
    axis tight
end