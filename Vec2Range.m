function out=Vec2Range(in)
%in should be a logical list
in=in>0;
x=diff([0 in]);
sts=find(x==1);
eds=find(x==-1);
eds=eds-1;
try
    if(sts(end)>eds(end))
        eds(end)=length(in);
    end
end
out=[sts ;eds]';