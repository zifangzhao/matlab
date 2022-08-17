function plot_stack(xdata,ydata,offset,opt)
if isempty(xdata)
    xdata=1:size(ydata,1);
end

plot(xdata,bsxfun(@minus,ydata,offset*(0:size(ydata,2)-1)),opt);