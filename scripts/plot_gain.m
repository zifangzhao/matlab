%% script to plot gain figure cross files
close all
mfiles=dir('*.mat');
m=cell(length(mfiles),1);
for idx=1:length(mfiles)
    m{idx}=load(mfiles(idx).name);
    m{idx}.filename=mfiles(idx).name;
end
color_list={'b','r','g','k','m','c'};
figure(1) %plot the gain
clf
hold on
for idx=1:length(m)
    shadedErrorBar(m{idx}.freq_list,m{idx}.Mean,{@median,@ste},color_list{idx});
end
ylim([0 1]);
fn=cellfun(@(x) strrep(x.filename,'_','\_'),m,'UniformOutput',0);
% fn={'R5 40K','R6 40K','R6 40K GND','R6 160K GND','R6 160K'};
legend(fn)
title('Signal-channel Gain')

figure(2) %plot the gain
clf
hold on
for idx=1:length(m)
    shadedErrorBar(m{idx}.freq_list,m{idx}.gnd_Mean,{@median,@ste},color_list{idx});
end
legend(fn)
ylim([0 1]);
title('Ground-channel Gain')


figure(3) %Cross-talk
clf
hold on
for idx=1:length(m)
    shadedErrorBar(m{idx}.freq_list,20*log10(m{idx}.gnd_Mean./m{idx}.Mean),{@median,@ste},color_list{idx});
end
legend(fn)
title('Cross-talk')
