function h=DAT_plot_band_events(LFP_events,plt_cmd,h)
if nargin<1
    uiload()
end
if nargin<2
    plt_cmd='b';
end
if nargin<3
    h=[];
end
Nch=length(LFP_events);
ch_valid=arrayfun(@(x) isempty(LFP_events{x}.gamma.wave.avg),1:Nch);
ch_valid=find(~ch_valid);
temp=arrayfun(@(x) LFP_events{x}.gamma.wave.avg,ch_valid,'UniformOutput',0);
LFP_gamma_plt=[temp{:}];
if isempty(h)
    h=figure(1);
end
subplot(121)
if ~isempty(h)
    hold on;
end
gam_scale=400;
y_center=gam_scale*(ch_valid-1);
hh=plot(LFP_events{1}.gamma.wave.tscale,bsxfun(@plus,LFP_gamma_plt,y_center),plt_cmd);
if length(hh)>1
    arrayfun(@(x) set(x,'HandleVisibility','off'),hh(2:end));
end
set(gca,'Ytick',y_center);
set(gca,'Yticklabel',arrayfun(@num2str,1:Nch,'UniformOutput',0));
axis ij;
axis tight;
ylim([y_center(1)-gam_scale,y_center(end)+gam_scale]);
title('Gamma Profile');
xlabel('Time(ms)');
hold off;
subplot(122)
if ~isempty(h)
    hold on;
end
ch_valid=arrayfun(@(x) isempty(LFP_events{x}.ripple.wave.avg),1:Nch);
ch_valid=find(~ch_valid);
temp=arrayfun(@(x) LFP_events{x}.ripple.wave.avg,ch_valid,'UniformOutput',0);
LFP_ripple_plt=[temp{:}];
rip_scale=100;
y_center=rip_scale*(ch_valid-1);
hh=plot(LFP_events{1}.ripple.wave.tscale,bsxfun(@plus,LFP_ripple_plt,y_center),plt_cmd);
if length(hh)>1
    arrayfun(@(x) set(x,'HandleVisibility','off'),hh(2:end));
end
set(gca,'Ytick',y_center);
set(gca,'Yticklabel',arrayfun(@num2str,1:Nch,'UniformOutput',0));
axis ij;
axis tight;
ylim([y_center(1)-rip_scale,y_center(end)+rip_scale]);
title('Ripple Profile');
xlabel('Time(ms)');
hold off
