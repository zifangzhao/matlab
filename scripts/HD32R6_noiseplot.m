%% script to plot noise freq figure cross files
mfiles=dir('*.mat');
m=cell(length(mfiles),1);
for idx=1:length(mfiles)
    m{idx}=load(mfiles(idx).name);
    m{idx}.filename=mfiles(idx).name;
end
color_list={'b','r','g','k','c','y'};
figure(1) %plot the gain
clf
hold on

freq_limit=500;

for idx=1:length(m)
    plot(m{idx}.f(3:freq_limit),m{idx}.pxx(3:freq_limit),color_list{idx})
end
% ylim([0 1]);
fn=cellfun(@(x) strrep(x.filename,'_','\_'),m,'UniformOutput',0);
% fn={'R5 40K','R6 40K','R6 40K GND','R6 160K GND','R6 160K'};
legend(fn)
title('Noise Power')
ylim([0 100])
