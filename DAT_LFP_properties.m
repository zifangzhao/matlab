% LFP properties of recording
freqlist=linspace(1,300,100);
convert_eff=0.195;
cal_len=60*10; %calculate window in seconds
snapshot_density=1000;
[f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files'},'MultiSelect','Off');
[Nch,fs,Nsamples,~,good_ch,time_bin]=DAT_xmlread([p f]);
f_LFP=dir( [p f(1:end-4) '_LFPprofile.mat']);
if(isempty(f_LFP))
    data=readmulti_frank([p f],Nch,1:Nch,0,cal_len*fs)*convert_eff;
    bandpower_avg=zeros(length(freqlist),Nch);
    bandpower_std=zeros(length(freqlist),Nch);
    bandpower_snapshot=zeros(snapshot_density,length(freqlist),Nch);
    snapshot_idx=round(linspace(1,size(data,1),snapshot_density));
    multiWaitbar('Processing data:',0);
    for ch=1:Nch
        X=awt_freqlist(data(:,ch),fs,freqlist,'Gabor');
        X=abs(X);
        bandpower_avg(:,ch)=median(X,1);
        bandpower_std(:,ch)=std(X,[],1);
        bandpower_snapshot(:,:,ch)=X(snapshot_idx,:);
        multiWaitbar('Processing data:',ch/Nch);
    end
    LFP_profile.mean=bandpower_avg;
    LFP_profile.std=bandpower_std;
    LFP_profile.name=[p f];
    LFP_profile.freqlist=freqlist;
    LFP_profile.snapshot.data=bandpower_snapshot;
    LFP_profile.snapshot.time=snapshot_idx/fs;
    save([p f(1:end-4) '_LFPprofile'], 'LFP_profile');
    multiWaitbar('Close all');
else
    disp('Previously computed LFP profile found.Loading...');
    load([p f(1:end-4) '_LFPprofile']);
end

%%  plotting snapshot
figure('Name',['LFP profile ' p f(1:end-4) '_LFPprofile']);
subplot(2,2,1)
f_idx=(freqlist>80)&(freqlist<300);
imagesc(1:Nch,freqlist(f_idx),(LFP_profile.mean(f_idx,:)));
axis xy;
set(gca,'xtick',1:Nch)
ylabel('Frequency');
% rotateticklabel(gca,90);
% ylim([100 300]);
xlabel('Channel');
colorbar;
rotateticklabel(gca,90);
% caxis([0 10])
title([f(1:end-4) '_LFPprofile'],'interpreter','none');

% caxis([0 300])

subplot(2,2,3)
f_idx=freqlist<80;
imagesc(1:Nch,freqlist(f_idx),(LFP_profile.mean(f_idx,:)));
axis xy;
set(gca,'xtick',1:Nch)
ylabel('Frequency');
% rotateticklabel(gca,90);
% ylim([100 300]);
xlabel('Channel');
colorbar;
rotateticklabel(gca,90);
% caxis([0 10])

subplot(2,2,2)
f_idx=(freqlist>80)&(freqlist<300);
imagesc(1:Nch,freqlist(f_idx),zscore(LFP_profile.mean(f_idx,:),[],1));
axis xy;
set(gca,'xtick',1:Nch)
ylabel('Frequency');
% ylim([0 80]);
xlabel('Channel');
title(['Normalized LFP profile']);
colorbar;
rotateticklabel(gca,90);
% caxis([0 300])

subplot(2,2,4)
f_idx=freqlist<80;
imagesc(1:Nch,freqlist(f_idx),zscore(LFP_profile.mean(f_idx,:),[],1));
axis xy;
set(gca,'xtick',1:Nch)
ylabel('Frequency');
% ylim([100 300]);
colorbar;
rotateticklabel(gca,90);
xlabel('Channel');
% caxis([0 10])

M=ceil(Nch^0.5);
N=round(Nch^0.5);
figure('Name',['Preview ' p f(1:end-4) '_LFPprofile']);
for ch=1:Nch
    subplot(M,N,ch);
    imagesc(LFP_profile.snapshot.time,freqlist,log10(LFP_profile.snapshot.data(:,:,ch)'));
    axis xy;
    title(['Ch:' num2str(ch)]);
    caxis([0 2])
end

