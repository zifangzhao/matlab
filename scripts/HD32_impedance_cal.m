%best impedance for HD32 calculating
f=1:1000;
c=linspace(10e-12,300e-12,500);
Ze=10e3+1/2/pi./f/1e-9;
Zin=bsxfun(@times,1/2/pi./f,1./c');
Gain=bsxfun(@times,Zin,Ze);
ctk=30e-12./(30e-12+c);