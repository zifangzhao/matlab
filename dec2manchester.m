function output=dec2manchester(input,digits,littleEnd)
if nargin<3
    littleEnd=1;
end
b=(dec2digits(input,digits));
o1=reshape(b',1,[]);
o2=~o1;
temp=fliplr(reshape([o1;o2],digits,[]));
if(littleEnd==1)
    ord=[2:2:size(temp,2);1:2:size(temp,2)];
    ord=reshape(ord,1,[]);
    temp=temp(:,ord);
end
output=reshape(dec2hex(temp'*2.^(0:(digits-1))')',1,[]);
