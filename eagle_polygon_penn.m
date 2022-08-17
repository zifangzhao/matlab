%generate hexagon in EaglePCB
diameter=4;
edge=6;
penn_width=0.3;
angle=2*pi/6;
radius=diameter/cos(angle);
x=radius*cos(angle*(1+(1:(edge+1))));
y=radius*sin(angle*(1+(1:(edge+1))));

layer=[1 29 31];
linewidth=0.2;
x_pen=x(end-1:end);
y_pen=y(end-1:end);


x_add=[x(1:end-1) mean(x_pen) + cos(atan(diff(y_pen)/diff(x_pen)))*penn_width,mean(x_pen) - cos(atan(diff(y_pen)/diff(x_pen)))*penn_width,x(end)];
y_add=[y(1:end-1) mean(y_pen) + sin(atan(diff(y_pen)/diff(x_pen)))*penn_width, mean(y_pen) - sin(atan(diff(y_pen)/diff(x_pen)))*penn_width,y(end)];    

cmd=arrayfun(@(xx) ['(' num2str(x_add(xx)) ' ' num2str(y_add(xx)) ') '],1:(length(x_add)-2),'UniformOutput',0);
cmd1=arrayfun(@(xx) ['(' num2str(x_add(xx)) ' ' num2str(y_add(xx)) ') '],(length(x_add)-1):length(x_add),'UniformOutput',0);
cmd_text=['grid MM;'];
for idx=1:length(layer)
    cmd_text=[ cmd_text ' CHANGE LAYER ' num2str(layer(idx)) '; SET WIRE_BEND 2;WIRE ' num2str(linewidth) ' ' cat(2,cmd{:}) '; WIRE ' num2str(linewidth) ' ' cat(2,cmd1{:}) ';'] ;
end
disp(cmd_text)
% WIRE 0 (51.000 0.000) (25.500 44.167) (-25.500 44.167) (-51.000 0.000) (-25.500 -44.167) (25.500 -44.167) (51.000 0.000);
