function soundsignal(signal,digits,samplingrate)
if nargin<3
    samplingrate=1000;
end
bin_code=dec2bin(signal,digits);
<<<<<<< HEAD
data=2*[1 1 0 arrayfun(@(x) str2num(bin_code(x)),1:length(bin_code)) 1 1];
data=data'*ones(1,10);
data=reshape(data',1,[]);
sound(data,96000);

=======
data=[1 0 arrayfun(@(x) str2num(bin_code(x)),1:length(bin_code)) 0 1];
sound(data,samplingrate);
>>>>>>> 39446a037b5d1f715976cfdb3145d211955b6ca0


