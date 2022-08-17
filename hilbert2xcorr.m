%% hilbert AmpXcorr
function Xc=analytic2xcorr(X)
% Input parameters
% X - 4D analytic signal, Time x Channel x Freq x Trial
Nch=size(X,2);
freq=size(X,3);
n=size(X,4);
Xc=zeros(Nch,Nch,freq,freq,n);
% Output parameter
% Xc - 5D Xcorr matrix, Ch x Ch x Freq x Freq x Trial
for ind=1:n
    for f1=1:freq
        for f2=f1:freq
            d1=abs(X(:,:,f1,ind));
            d2=abs(X(:,:,f2,ind));
            Xc(:,:,f1,f2,ind)=corr(d1,d2);
        end
    end
end
                