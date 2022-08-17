CD=logspace(-12,-9,100);
RE=logspace(1,6,100);

tau=CD'*RE;

contour(log10(CD),log10(RE),log10(2*pi*tau)',-10:-3)
colormap jet
