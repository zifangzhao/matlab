function rgb=hsv2rgb_frank(H,s,v)
dim=max([length(H),length(s),length(v)]);
hsv=ones(dim,3);
hsv(:,1)=H;
hsv(:,2)=s;
hsv(:,3)=v;
rgb=hsv2rgb(hsv);