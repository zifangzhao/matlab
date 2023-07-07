function xc = DAT_Xcorr(data)
%xc = mscohere(data,data,'mimo');
Nch = size(data,2);
xc=zeros(Nch,Nch);
for x=1:Nch
    parfor y=1:Nch
        xc(x,y) = amp_correlation_hilbert(data(:,x),data(:,y));
    end
end