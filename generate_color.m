function color=generate_color(N,hue_range)
if nargin<2
    hue_range=[0 1];
end
hue_this=linspace(hue_range(1),hue_range(2),N);
hue_this=hue_this-fix(hue_this);
color=arrayfun(@(x) hsv2rgb([x,1,1]),hue_this,'UniformOutput',0);