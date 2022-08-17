%generate hexagon in EaglePCB
diameter=2;
edge=6;
angle=2*pi/6;
radius=diameter/cos(angle);
x=radius*cos(angle*(1:(edge+1)));
y=radius*sin(angle*(1:(edge+1)));

layer=[1 29 31];
linewidth=0.2;
cmd=arrayfun(@(xx) ['(' num2str(x(xx)) ' ' num2str(y(xx)) ') '],1:length(x),'UniformOutput',0);

cmd_text=['grid MM;'];
for idx=1:length(layer)
    cmd_text=[ cmd_text ' CHANGE LAYER ' num2str(layer(idx)) '; SET WIRE_BEND 2;WIRE ' num2str(linewidth) ' ' cat(2,cmd{:}) ';'] ;
end
disp(cmd_text)
% WIRE 0 (51.000 0.000) (25.500 44.167) (-25.500 44.167) (-51.000 0.000) (-25.500 -44.167) (25.500 -44.167) (51.000 0.000);
