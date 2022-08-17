function DAT_compare_band_events()
[f_d,p]=uigetfile('*_LFPEvents.mat','Multiselect','on');
if ~iscell(f_d)
    temp=f_d;
    f_d=cell(1);
    f_d{1}=temp;
end

if length(f_d)>6
    error('Only equal or less than 6 files can be displayed at same time, try select less files')
else
    clr={'b','r','g','c','m','y','k'};
    h=figure(1);
    clf(h);
    for idx=1:length(f_d)
        load([p f_d{idx}])
        DAT_plot_band_events(LFP_events,clr{idx},h);
    end
    legend(f_d,'interpreter','none');
end
