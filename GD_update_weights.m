function [m,b]=GD_update_weights(m,b,X,Y,rate)
md=0;
bd=0;
N=length(x);
for idx=1:N
    md=-2*X(idx)*(Y(idx)-(m*X(idx)+b));
    bd=-2*(Y(idx)-(m*X(idx)+b);
end
m=m-(md/N)*rate;
b=b-(bd/N)*rate;
