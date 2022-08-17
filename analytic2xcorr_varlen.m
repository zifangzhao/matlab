%% hilbert AmpXcorr
function Xc=analytic2xcorr_varlen(X)
% Input parameters
% X - cellular 3D analytic signal, {trial} Time x Channel x Freq
Nch=size(X{1},2);
freq=size(X{1},3);
n=length(X);
Xc=zeros(Nch,Nch,freq,freq,n);
% Output parameter
% Xc - 5D Xcorr matrix, Ch x Ch x Freq x Freq x Trial
for ind=1:n
    for f1=1:freq
        for f2=f1:freq
            d1=abs(X{ind}(:,:,f1));
            d2=abs(X{ind}(:,:,f2));
            Xc(:,:,f1,f2,ind)=corr(d1,d2);
        end
    end
end
                