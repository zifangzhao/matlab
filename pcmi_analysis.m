%% Ixy Iyx analysis PCMI_analysis
%%2012-3-24 version revised by Zifang zhao,解决多重极点问题
function [Xmax Ymax XYmax]=pcmi_analysis(Ixy,Iyx)
Xmax.delay=[];Ymax.delay=[];XYmax.delay=[];
Xmax.DP=[];Ymax.DP=[];XYmax.DP=[];
Xmax.Ixy=[];Ymax.Ixy=[];XYmax.Ixy=[];
Xmax.Iyx=[];Ymax.Iyx=[];XYmax.Iyx=[];
if isempty(Ixy)
else
    [Ixy_xmax,delayx_idx]=max(Ixy);
    Ixy_xmax=Ixy_xmax(1);  %2012-3-24
    delayx_idx=delayx_idx(1);
    % delayx_idx=find(Ixy==Ixy_xmax);
    DP_xmax=(Ixy(delayx_idx) - Iyx(delayx_idx))/(Ixy(delayx_idx) + Iyx(delayx_idx));
    Xmax.delay=delayx_idx;
    Xmax.DP=DP_xmax;
    Xmax.Ixy=Ixy_xmax;
    Xmax.Iyx=Iyx(delayx_idx);
    
    [Iyx_ymax,delayy_idx]=max(Iyx);
    Iyx_ymax=Iyx_ymax(1);   %2012-3-24
    delayy_idx=delayy_idx(1); %2012-3-24
    % delayy_idx=find(Iyx==Iyx_ymax);  %2012-3-24
    DP_ymax=(Ixy(delayy_idx) - Iyx(delayy_idx))/(Ixy(delayy_idx) + Iyx(delayy_idx));
    Ymax.delay=delayy_idx;
    Ymax.DP=DP_ymax;
    Ymax.Ixy=Ixy(delayy_idx);
    Ymax.Iyx=Iyx_ymax;
end
% delay_idx = findmax_vec(Ixy,Iyx);
% Ixy_max=Ixy(delay_idx);
% Iyx_max=Iyx(delay_idx);
% DP_max=(Ixy(delay_idx) - Iyx(delay_idx))/(Ixy(delay_idx) + Iyx(delay_idx));
% XYmax.delay=delay_idx;
% XYmax.DP=DP_max;
% XYmax.Ixy=Ixy_max;
% XYmax.Iyx=Iyx_max;
end