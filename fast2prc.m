function out = fast2prc(in)
%FAST2PRC Quickly find 2 and 98 percentile values
% P = FAST2PRC(X) returns approximate 2 and 98 percentile values
% for the vector X. For use in contrast stretching.
  
% Author: Peter Boettcher <boettcher@ll.mit.edu>
% Last modified: 3/30/2001
s = std(in);
l = length(in);
thresh = l/10;

T = .98 * l;

t = mean(in) + 2*s;
step = s/4;
prev = -1;

d = sum(in<t) - T;
while(abs(d) > thresh)
   if(d<0)
      if (prev == 1)
         step = step/2;
      end
      t = t + step;
      prev = 0;
   else
      if (prev == 0)
         step = step/2;
      end
      t = t - step;
      prev = 1;
   end
   d = sum(in<t) - T;
end

out(2) = t;

T = .02 * l;

t = mean(in) - 2*s;
step = s/4;
prev = -1;

d = sum(in<t) - T;
while(abs(d) > thresh)
   if(d<0)
      if (prev == 1)
         step = step/2;
      end
      t = t + step;
      prev = 0;
   else
      if (prev == 0)
         step = step/2;
      end
      t = t - step;
      prev = 1;
   end
   d = sum(in<t) - T;
end

out(1) = t;