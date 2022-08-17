function out=dec2digits(decimal,N)
len=length(decimal);
if size(decimal,1)>1
    decimal=decimal';
end
out=false(len,N);
for d=1:N
    out(:,d)=mod(decimal,2*ones(1,len))==1;
    decimal=floor(decimal/2);
end