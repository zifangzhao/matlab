function loc=judge(a,b)
temp=find(a==b(1));
for m=2:length(b)
    if(isempty(temp))
    else
        temp_in=[];
        temp=temp+1;
        temp=temp(temp<=length(a));
        for n=1:length(temp)
            if(a(temp(n))==b(m))
                temp_in=[temp_in temp(n)];
            end
        end
        temp=temp_in;
    end
end
if(isempty(temp))
else
    loc=temp-length(b)+1;
end
end