%find Ixy or Iyx max delay
function [Ixy_delay,Iyx_delay,Ixy_DP,Iyx_DP]=Imax_delay(Ixy,Iyx,delay,channel_mask)

%% ≥ı ºªØ
% t_test=[];
% ks_test=nan;

loc_map=ones(size(Ixy))-cellfun(@isempty,Ixy);
if(nargin<4)
    non_zeros_locs=find(loc_map);
else
    non_zeros_locs=find(loc_map.*channel_mask);
end
if(isempty(non_zeros_locs))
    Ixy_delay=nan;
    Iyx_delay=nan;
    Ixy_DP=nan;
    Iyx_DP=nan;
else
    Ixy_selected=Ixy(non_zeros_locs);
    Iyx_selected=Iyx(non_zeros_locs);
    delay_selected=delay(non_zeros_locs);

    
    Ixy_selected_line=[Ixy_selected{:}];
    Iyx_selected_line=[Iyx_selected{:}];
    delay_selected_line=[delay_selected{:}];
    
    delay_uni=sort(unique(delay_selected_line));
    Ixy_avg=zeros(1,length(delay_uni));
    Iyx_avg=zeros(1,length(delay_uni));
    for dly=1:length(delay_uni)
        Ixy_temp=Ixy_selected_line(delay_selected_line==delay_uni(dly));
        Iyx_temp=Iyx_selected_line(delay_selected_line==delay_uni(dly));
        Ixy_avg(dly)=sum(Ixy_temp)/length(Ixy_temp);
        Iyx_avg(dly)=sum(Iyx_temp)/length(Iyx_temp);
    end
    Ixy_delay=delay_uni(Ixy_avg==max(Ixy_avg));Ixy_Midx=find(Ixy_avg==max(Ixy_avg));
    Iyx_delay=delay_uni(Iyx_avg==max(Iyx_avg));Iyx_Midx=find(Iyx_avg==max(Iyx_avg));
    Ixy_delay=Ixy_delay(1);Ixy_DP=(Ixy_avg(Ixy_Midx(1)) - Iyx_avg(Ixy_Midx(1)))/(Ixy_avg(Ixy_Midx(1)) + Iyx_avg(Ixy_Midx(1)));
    Iyx_delay=Iyx_delay(1);Iyx_DP=(Ixy_avg(Iyx_Midx(1)) - Iyx_avg(Iyx_Midx(1)))/(Ixy_avg(Iyx_Midx(1)) + Iyx_avg(Iyx_Midx(1)));
end
end

