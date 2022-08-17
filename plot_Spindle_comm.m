if ~exist('ind')
    ind=1;
end
subplot(511);
imagesc(t,1:0.5:50,abs(data_wave{ind})');
axis xy;
xlim([-1 4]);
ylim([5 50]);
caxis([0 100]);
t_sel=(t>0.2&t<1.7);
% spindle_index=smooth(data_power_ts{ind},1);
spindle_index=smooth(data_power_ts{ind}.*data_power_ts{ind}./smooth(exp(0.5).^data_power_high{ind},300),374);
disp([num2str(ind) ' _ ' num2str(max(spindle_index(t_sel)))]);

subplot(512);
plot(t,data{ind}+1000);
hold on;
plot(t,data_chn2{ind}-1000,'r'); 
ylim([-4000 4000]);
hold off;

subplot(513)

plot(t,data_power_ts{ind}./data_power_low{ind});
hold on;
plot(t,smooth(data_power_ts{ind}./data_power_low{ind},374),'r');
hold off;

subplot(514)
plot(t,data_power_high{ind});
subplot(515)
plot(t,spindle_index);
ylim([0 1000]);

% plot(t,data_power_ts_smooth{ind});
% hold off;
% xlim([-1 4]);
ind=ind+1;