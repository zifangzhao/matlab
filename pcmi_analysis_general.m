%% pcmi_analysis general
%% load data

%% ±éÀúdelay
trial_len=length(Ixys);

for trial=1:trial_len
    for x=1:length(Ixys{1})
        for y=1:length(Ixys{1})
            if(isempty(Ixys{trial}{x,y}))
                delayx{trial}{x,y}=[];
                DPx{trial}{x,y}=[];
                Ixy_xmax{trial}{x,y}=[];
                Iyx_xmax{trial}{x,y}=[];
            else
                [Xmax Ymax XYmax]=pcmi_analysis(Ixys{trial}{x,y},Iyxs{trial}{x,y});
                delayx{trial}{x,y}=Xmax.delay;
                DPx{trial}{x,y}=Xmax.DP;
                Ixy_xmax{trial}{x,y}=Xmax.Ixy;
                Iyx_xmax{trial}{x,y}=Xmax.Iyx;
            end
        end
    end
end
clear('Xmax','Ymax','XYmax');
idx_temp=[];
dp_temp=[];
Ixy_temp=[];
Iyx_temp=[];

for trial=1:trial_len
    for x=1:3
        for y=4:8
            dp_temp=[dp_temp DPx{trial}{x,y}];
            Ixy_temp=[Ixy_temp Ixy_xmax{trial}{x,y}];
            Iyx_temp=[Iyx_temp Iyx_xmax{trial}{x,y}];
            idx_temp=[idx_temp delayx{trial}{x,y}];
        end
    end
end
subplot(2,2,1)
% scatter(idx_temp,dp_temp); 
scatter(idx_temp,dp_temp,'y'); 
ylabel('DP');
xlabel('Delay(1/fs)');
subplot(2,2,2)
% scatter(idx_temp,Ixy_temp,'r+'); 
scatter(idx_temp,Ixy_temp,'g+'); 
ylabel('Ixy');
xlabel('Delay(1/fs)');
subplot(2,2,3)
% scatter(idx_temp,Iyx_temp,'kd'); 
scatter(idx_temp,Iyx_temp,'md'); 
ylabel('Iyx');
xlabel('Delay(1/fs)');