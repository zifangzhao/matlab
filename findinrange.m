%%find bhv in time_range, the later one as limitation
function bhv_time=findinrange(bhv,time_range)
bhv_size=size(bhv);
bhv_time=[];
for a=1:bhv_size(1)
    if(bhv(a,1)>=time_range(1)&&bhv(a,2)<=time_range(2))
       bhv_time=[bhv_time;bhv(a,:)]; 
    end
end


 