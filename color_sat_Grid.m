function color=color_sat_Grid(N,h)
if nargin<2
    h=0;
end
hsv=zeros(N,3);
hsv(:,2)=h;
hsv(:,1)=0.5;
hsv(:,3)=linspace(0,0.8,N);
color=hsv2rgb(hsv);

