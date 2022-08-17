%% Detect band activity based on FMAToolbox
function DAT_detect_band_event()
[f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files'},'MultiSelect','Off');
 [Nch,fs,Nsamples,~,good_ch,time_bin]=DAT_xmlread([p f]);
data=readmulti_frank([p f],Nch,good_ch,0,inf);
t_win_gam=[-100 100]; %time window in ms
t_win_rip=[-20 20];
t_idx_gam=round(t_win_gam(1)/fs*1000):round(t_win_gam(2)/fs*1000);
t_idx_rip=round(t_win_rip(1)/fs*1000):round(t_win_rip(2)/fs*1000);
LFP_events=cell(Nch,1);
%%
if matlabpool('size')>0
    disp('MATLAB pool has been detected, running in parallel computing mode, index maybe out of order, no big deal...');
    parfor ch=1:Nch
        LFP_events{ch}=data_processer(f,p,data,t_idx_gam,t_idx_rip,ch,Nch,fs,time_bin);
    end
else
    for ch=1:Nch
        LFP_events{ch}=data_processer(f,p,data,t_idx_gam,t_idx_rip,ch,Nch,fs,time_bin);
    end
end


save([p f(1:end-4) '_LFPEvents'],'LFP_events');

%% plotting band activities
h=DAT_plot_band_events(LFP_events);
print(h,[p f(1:end-4) '.jpg']);
end
function LFP_events=data_processer(f,p,data,t_idx_gam,t_idx_rip,ch,Nch,fs,time_bin)
    fprintf(2,['Detecting Gamma Events:' num2str(ch) '/' num2str(Nch) '\n'])
    t=(1:size(data,1))'/fs;
    fil_gam= FilterLFP([t data(:,ch)], 'passband', [30 80]);
    [gamma,sd,bad] = FindRipples(fil_gam,'thresholds', [3 5], 'durations', [30 300 50],'frequency',fs,'stdev',median(fil_gam(:,2).^2));
    fil_rip= FilterLFP([t data(:,ch)], 'passband', [150 250]);
    fprintf(2,['Detecting Ripple Events:' num2str(ch) '/' num2str(Nch) '\n'])
    [rip,sd,bad] = FindRipples(fil_rip,'thresholds', [3 5], 'durations', [30 100 20],'frequency',fs,'stdev',median(fil_rip(:,2).^2));
    LFP_events.gamma.time=gamma;
    LFP_events.ripple.time=rip;
    DAT_SaveEvents([p f(1:end-4) '.g' num2str(ch-1,'%.2d') '.evt'],gamma,ch-1,'Gamma');
    DAT_SaveEvents([p f(1:end-4) '.r' num2str(ch-1,'%.2d') '.evt'],gamma,ch-1,'Ripple');
    t_gam=round(gamma(:,2)*fs); %peak gamma time in sample
    t_rip=round(rip(:,2)*fs);
    if ~isempty(time_bin)
        disp('Noise detection file found, noisy data have been skipped...')
        t_gam=t_gam(time_bin(t_gam));
        t_rip=t_rip(time_bin(t_rip));
    end
    t_gam((t_gam+t_idx_gam(end))>size(fil_gam,1))=[];
    t_gam((t_gam+t_idx_gam(1))<=0)=[];
    t_rip((t_rip+t_idx_rip(end))>size(fil_rip,1))=[];
    t_rip((t_rip+t_idx_rip(1))<=0)=[];
    LFP_gamma_temp=arrayfun(@(x) fil_gam(x+t_idx_gam,2),t_gam,'UniformOutput',0);
    LFP_ripple_temp=arrayfun(@(x) fil_rip(x+t_idx_rip,2),t_rip,'UniformOutput',0);
    LFP_gamma_mat=[LFP_gamma_temp{:}];
    LFP_ripple_mat=[LFP_ripple_temp{:}];
    LFP_events.gamma.wave.avg=median(LFP_gamma_mat,2);
    LFP_events.gamma.wave.std=std(LFP_gamma_mat,[],2);
    LFP_events.gamma.wave.tscale=t_idx_gam*fs/1000;
    LFP_events.ripple.wave.avg=median(LFP_ripple_mat,2);
    LFP_events.ripple.wave.std=std(LFP_ripple_mat,[],2);
    LFP_events.ripple.wave.tscale=t_idx_rip*fs/1000;
end

