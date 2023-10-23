function color=color_sat_Grid(N,c,h)
if nargin<3
    h=0;
end
if nargin<2
    c=0.5;
end
hsv=zeros(N,3);
hsv(:,2)=h;
hsv(:,1)=c;
hsv(:,3)=linspace(0,0.8,N);
color=hsv2rgb(hsv);

