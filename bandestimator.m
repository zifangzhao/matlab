function [L,H]=bandestimator(X,Y,max_step)
% tau1=0.05;
% tau2=0.00001;
% f=logspace(1,5,1000);
% h=1./(1+(2*pi.*tau1.*f).^-1).*1./(1+2*pi.*tau2.*f);
% 
% % f=fit(f',h',{'rat01'});
% plot(h)
% 
% 
% %% fitting
% Y=h;%+rand(size(h));
% X=f;
% 
% Y=mapminmax(Y',0,1)';
Y=Y-prctile(Y,5);
drawfig=1;
N=length(X);

H=1e-6;
L=1e-3;
G=1/0.2;
rate=0.010;
vtH=0;
vtL=0;
vtG=0;
adp_rate=0.6;
for repeat=1:max_step
    dl=0;
    dh=0;
    dg=0;
    for idx=1:length(X)
        dl=dl+ 2*(Y(idx)-G*(1+(L*X(idx))^-1)^-1/(H*X(idx)+1))*(-L*G)/(H*X(idx)+1)/(L*X(idx)+1)^2;
        dh=dh+ 2*(Y(idx)-G*(1+(L*X(idx))^-1)^-1/(H*X(idx)+1))*H*G/(1+(L*X(idx))^-1)*(H*X(idx)+1)^-2;
        dg=dg-2*(Y(idx)-G*(1+(L*X(idx))^-1)^-1/(H*X(idx)+1))/(1+1/L/X(idx))/(1+H*X(idx));
    end
    vtH=vtH*adp_rate+(dh/N);
    vtL=vtL*adp_rate+(dl/N);
    vtG=vtG*adp_rate+(dg/N);
    vtH=(dh/N)*rate;
    vtL=(dl/N)*rate;
    vtG=(dg/N)*rate;
    H=H-vtH;
    L=L-vtL;
    G=G-vtG;
    err=sum((Y-(G./(1+(L.*X).^-1)./(H.*X+1))).^2);
    disp(['Step:' num2str(repeat) ' H:' num2str(H) ' L:' num2str(L) ' G:' num2str(G) ' Error:' num2str(err)])
    if drawfig==1 && mod(repeat,500)==0
        f_h=@(x) G./(1+1./(L*x))./(H*x+1);
        plot(X,Y);
        hold on;
        plot(X,f_h(X),'r')
        hold off;
        drawnow;
    end
end
%%
