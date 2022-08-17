%CE/CD

CD=logspace(-12,-9,100);
fs=logspace(1,6,100);
f=1000;

Zin=zeros(length(CD),length(fs));
for a=1:length(CD)
    for b=1:length(fs)
        Zsw=1/fs(b)/CD(a);
        Zc=1/2/pi/f./CD(a);
        Zin(a,b)=1./(1./Zsw+1./Zc);
    end
end
contour(log10(CD),log10(fs),log10(Zin)',4:8);
colormap jet
xlabel('C_D(Farad)')
ylabel('Sampling Rate (Hz)')
c=colorbar;
c.Label.String='Input Impedance(Ohm)';