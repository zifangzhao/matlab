% load seamount%一列x一列y一列z
% scatter(x,y,5,z)%散点图
% figure
% [X,Y,Z]=griddata(x,y,z,linspace(210.8,211.8)',linspace(-48.45,-47.95),'v4');%插值
% pcolor(X,Y,Z);shading interp%伪彩色图
% figure
% contourf(X,Y,Z) %等高线图
function densityPlot(x,y,z,res)
xrange=linspace(min(x),max(x),res);
yrange=linspace(min(y),max(y),res); 
% Z=interp2(sort(x),sort(y),[map tag],xrange,yrange);
% [X,Y,Z]=griddata(x,y,z,xrange',yrange,'linear');%插值
% pcolor(X,Y,Z);shading interp%伪彩色图
vq=griddata(x,y,z,xrange',yrange,'linear');%插值
imagesc(xrange,yrange,vq);
axis tight
% contourf(X,Y,Z,length(unique(z))) %等高线图,'linestyle','none'