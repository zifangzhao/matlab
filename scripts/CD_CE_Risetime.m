CD=22e-12;
fs=logspace(1,5,10);
Zsw=1./(fs*CD);
CE=logspace(-10,-6,100);
tau=Zsw'*CE;
contour(log10(fs),log10(CE),log10(2*pi*tau'));
colormap jet
