function printfcn(xdata,ydata,data,title_text,filename)
h=figure();
%%put your figure here
imagesc;
title(title_text);

%%print to file
print(h,filename,'-depsc')