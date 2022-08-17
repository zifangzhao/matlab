function [z,freq]=impedance_sim(freq,c,rs)
f_zc=@(c,f) 1/2/pi./f./c;
f_z=@(c,r,f) sqrt(bsxfun(@plus,f_zc(c,f)'.^2,r.^2));
z=f_z(c,rs,freq);
loglog(freq,z);
ylabel('Z(ohm)')
xlabel('Frequency(hz)')