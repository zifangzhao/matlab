% function [c,rs]=impedance_fit(freq,Z)

freq=logspace(1,8,500)';
% freq=linspace(1,1e8,500)';
f_zc=@(c,f) 1/2/pi./f./c;
f_z=@(c,r,f) sqrt(bsxfun(@plus,f_zc(c,f)'.^2,r.^2));

c=1e-9;
r=1e5;

Z=f_z(c,r,freq)';

g = fittype('((1/2/pi/f/c)^2+r^2)^0.5','coefficients',{'c','r'},'independent','f');
fo = fitoptions('Method','NonlinearLeastSquares',...
    'Normal','off',...
    'StartPoint',[1,1],...
    'Lower',[1e-12,1e3],...
    'Upper',[1e-6,1e12]);

F=fit(freq,Z,g,fo);
fitted=F(freq);
loglog(freq,Z)
hold on;
loglog(freq,fitted,'r');
hold off;