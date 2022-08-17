% find max value
function v=find_max_v(data) %find max value in the delay axis
temp=max(data,[],1);
v=mean(temp);
