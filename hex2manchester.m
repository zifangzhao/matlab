function output=hex2manchester(input,digits)
data=cellfun(@hex2dec,input);
b=(dec2digits(data,digits));
o1=reshape(b',1,[]);
o2=~o1;
temp=(reshape([o1;o2],digits,[]));
output=dec2hex(temp'*2.^(0:(digits-1))');

