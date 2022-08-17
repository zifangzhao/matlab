function x=nan2zero(x,dim)
if nargin<2
    x(isnan(x))=0;
    x(isinf(x))=0;
else
    loc1=sum(isnan(x),dim);
    loc2=sum(isinf(x),dim);
    loc=loc1>0|loc2>0;
    if dim==1
        x(:,loc)=0;
    else
        x(loc,:)=0;
    end
end
    
    