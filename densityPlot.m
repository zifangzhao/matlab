% load seamount%һ��xһ��yһ��z
% scatter(x,y,5,z)%ɢ��ͼ
% figure
% [X,Y,Z]=griddata(x,y,z,linspace(210.8,211.8)',linspace(-48.45,-47.95),'v4');%��ֵ
% pcolor(X,Y,Z);shading interp%α��ɫͼ
% figure
% contourf(X,Y,Z) %�ȸ���ͼ
function densityPlot(x,y,z,res)
xrange=linspace(min(x),max(x),res);
yrange=linspace(min(y),max(y),res); 
% Z=interp2(sort(x),sort(y),[map tag],xrange,yrange);
% [X,Y,Z]=griddata(x,y,z,xrange',yrange,'linear');%��ֵ
% pcolor(X,Y,Z);shading interp%α��ɫͼ
vq=griddata(x,y,z,xrange',yrange,'linear');%��ֵ
imagesc(xrange,yrange,vq);
axis tight
% contourf(X,Y,Z,length(unique(z))) %�ȸ���ͼ,'linestyle','none'