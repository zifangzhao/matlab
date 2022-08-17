function Y=IIR_test(b,a,data)
a=-a;
ord=length(a);
temp=zeros(length(data)+ord,1);
fil_temp=zeros(length(data)+ord,1);
temp(ord+1:end)=data;
for i=1:length(data)
    fil_temp(i+ord)=(sum(fliplr(b)'.*temp(i+1:i+ord))+sum(fliplr(a(2:end))'.*fil_temp(i+1:i+ord-1)))/-a(1);
end
Y=fil_temp(ord+1:end)';
    