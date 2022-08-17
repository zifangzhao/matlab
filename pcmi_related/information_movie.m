fig=figure(6);
ell_sze=[0.2 0.2];
ell_loc=[0 0.5-ell_sze(2)/2;0.5-ell_sze(1)/2 1-ell_sze(2);1-ell_sze(1) 0.5-ell_sze(2)/2;0.5-ell_sze(1)/2 0];
ell_clr=[0 1 0;1 0 0; 1 0 1 ; 0 0 1];
%drawing brain regions & tags
for idx=1:size(ell_loc,1)
    annotation(fig,'ellipse',...
        [ell_loc(idx,:) ell_sze],...
        'LineStyle','-',...
        'LineWidth',1,...
        'FaceColor',ell_clr(idx,:));

     annotation('textbox',[ell_loc(idx,1)+0.07,ell_loc(idx,2)+0.04 0.1 0.1],...
         'String',region_name{idx},...
         'LineStyle','none')
end
region_plot_all=[];
for rgn1=1:length(region)
    for rgn2=1:length(region)
        for vec=1:size(region_plot_out{rgn1,rgn2},1)
            region_plot_all=[region_plot_all ;rgn1,rgn2,region_plot_out{rgn1,rgn2}(vec,3:4)];
        end
    end
end

loc_inner=[0 0.5 ell_sze(1) 0.5;...
    0.5-ell_sze(1)/2 1-ell_sze(2)/2 0.5+ell_sze(1)/2 1-ell_sze(2)/2;...
    1-ell_sze(1)/2 0.5-ell_sze(2)/2 1-ell_sze(1)/2 0.5-ell_sze(2)/2;...
    0.5-ell_sze(1)/2 0+ell_sze(2)/2 0.5+ell_sze(1)/2 0+ell_sze(2)/2];

