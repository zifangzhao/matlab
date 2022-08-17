function [t_test ks_test]=pcmi_region_stat(A,B,channel_mask_A,channel_mask_B,filename,LegendA,LegendB)%A B =pcmi_all_data,consist of Ixy_delay Iyx_delay
Ixy_delayA=[];
Ixy_delayB=[];
Iyx_delayA=[];
Iyx_delayB=[];
t_test.Ixy=nan;
t_test.Ixy_delay=nan;
t_test.Iyx=nan;
t_test.Iyx_delay=nan;
ks_test.Ixy=nan;
ks_test.Ixy_delay=nan;
ks_test.Iyx=nan;
ks_test.Iyx_delay=nan;
if nargin<6
    LegendA='A';
    LegendB='B';
end
if(isempty(A.Ixy_delay))
else
    if nargin>2
        channel_mask_A=reshape(channel_mask_A,1,[]);
        for a=1:size(A.Ixy_delay{1},1)*size(A.Ixy_delay{1},2)
            loc_map_A(a)=1-isempty(A.Ixy_delay{1}{a});            %确定相应cell是否为空的表
        end
        non_zero_locs_A=find(loc_map_A.*channel_mask_A);
    else
        
        for a=1:size(A.Ixy_delay{1},1)*size(A.Ixy_delay{1},2)
            loc_map_A(a)=1-isempty(A.Ixy_delay{1}{a});            %确定相应cell是否为空的表
        end
        non_zero_locs_A=find(loc_map_A);
    end
    if(isempty(non_zero_locs_A))
        Ixy_delayA=[];
    else
        for a=1:length(non_zero_locs_A)
            Ixy_delayA=[Ixy_delayA ; A.Ixy_delay{1}{non_zero_locs_A(a)}];
            Iyx_delayA=[Iyx_delayA ; A.Iyx_delay{1}{non_zero_locs_A(a)}];
        end
    end
end
if(isempty(B.Ixy_delay))
else
    if nargin>3
        
        for a=1:size(B.Ixy_delay{1},1)*size(B.Ixy_delay{1},2)
            loc_map_B(a)=1-isempty(B.Ixy_delay{1}{a});            %确定相应cell是否为空的表
        end
        channel_mask_B=reshape(channel_mask_B,1,[]);
        non_zero_locs_B=find(loc_map_B.*channel_mask_B);
    else
        
        for a=1:size(B.Ixy_delay{1},1)*size(B.Ixy_delay{1},2)
            loc_map_B(a)=1-isempty(B.Ixy_delay{1}{a});            %确定相应cell是否为空的表
        end
        non_zero_locs_B=find(loc_map_B);
    end
    if(isempty(non_zero_locs_B))
        Ixy_delayB=[];
    else
        for a=1:length(non_zero_locs_B)
            Ixy_delayB=[Ixy_delayB ; B.Ixy_delay{1}{non_zero_locs_B(a)}];
            Iyx_delayB=[Iyx_delayB ; B.Iyx_delay{1}{non_zero_locs_B(a)}];
        end
    end
end
if(isempty(Ixy_delayA))
else
    scatter(Ixy_delayA(:,2),Ixy_delayA(:,1),'.b');
    hold on
    if(isempty(Ixy_delayB))
        legend(LegendA)
    else
        [~,t_test.Ixy]=ttest2(Ixy_delayA(:,1),Ixy_delayB(:,1));
        [~,t_test.Ixy_delay]=ttest2(Ixy_delayA(:,2),Ixy_delayB(:,2));
        [~,ks_test.Ixy]=kstest2(Ixy_delayA(:,1),Ixy_delayB(:,1));
        [~,ks_test.Ixy_delay]=kstest2(Ixy_delayA(:,2),Ixy_delayB(:,2));
        scatter(Ixy_delayB(:,2),Ixy_delayB(:,1),'xr');legend(LegendA,LegendB);
    end
    hold off
    xlabel('delay')
    ylabel('Ixy');
    
    xlim([0 100]);
    if nargin>4
    else
        filename='Ixy_delay of two region';
    end
    print('-djpeg90',[filename '_Ixy']);
end
if(isempty(Ixy_delayA))
    
else
    scatter(Iyx_delayA(:,2),Iyx_delayA(:,1),'.b');
    hold on
    if(isempty(Ixy_delayB))
        legend(LegendA);
    else
        [~,t_test.Iyx]=ttest2(Iyx_delayA(:,1),Iyx_delayB(:,1));
        [~,t_test.Iyx_delay]=ttest2(Iyx_delayA(:,2),Iyx_delayB(:,2));
        [~,ks_test.Iyx]=kstest2(Iyx_delayA(:,1),Iyx_delayB(:,1));
        [~,ks_test.Iyx_delay]=kstest2(Iyx_delayA(:,2),Iyx_delayB(:,2));
        scatter(Iyx_delayB(:,2),Iyx_delayB(:,1),'xr');legend(LegendA,LegendB);
    end
    hold off
    xlabel('delay')
    ylabel('Iyx');
    xlim([0 100]);
    
    if nargin>4
    else
        filename='Iyx_delay of two region';
    end
    print('-djpeg90',[filename '_Iyx']);
end

%     [~,test.Ixy]=ks_test2(Ixy_A,Ixy_B);
%     [~,test.Iyx]=ks_test2(Iyx_A,Iyx_B);
%     [~,test.DP]=ks_test2(DP_A,DP_B);
%     [~,test.delay]=ks_test2(delay_A,delay_B);
%
%     scatter(DP_A,Ixy_A,'b')
%     hold on
%     scatter(DP_B,Iyx_B,'r');
%     hold off;
