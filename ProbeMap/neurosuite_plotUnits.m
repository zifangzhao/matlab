function neurosuite_plotUnits(unit,waveform,fs,gain)
Avg_wave=cellfun(@(x) median(x,3),waveform,'uni',0);
N=ceil(length(waveform)^0.5);
shadedPlot=1;
for idx=1:length(waveform)
    subplot(N,N,idx);
    data=Avg_wave{idx};
    data=bsxfun(@minus,data,median(data,1));
    [~,max_wave_ch]=max(sum(abs(data),1));    
    t=(1:size(data,1))/fs*1000;
    if shadedPlot==0
        plot(t,gain.*squeeze(waveform{idx}(:,max_wave_ch,:)),'k');
        hold on;
        plot(t,gain.*data(:,max_wave_ch),'r')
        hold off;
    else
        shadedErrorBar(t,gain.*squeeze(waveform{idx}(:,max_wave_ch,:))',{@median,@std},'k');
    end

    title(['Unit ID' num2str(unit.clusterlist(idx)) ' Channel(Max Amp):' num2str(max_wave_ch-1)])
    xlabel('Time(ms)');
    ylabel('Amplitude(uV)');
end