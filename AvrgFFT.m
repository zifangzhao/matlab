function[Avrg]=AvrgFFT(pickdata)

scrdata=sort(pickdata);
scrdata(find(scrdata==0))=[];
scrdata(find(isnan(scrdata)==1))=[];
if mod(0.25*length(scrdata),1)==0;
    xn=0.25*length(scrdata);
    Q1=(scrdata(xn)+scrdata(xn+1))/2;
    Q3=(scrdata(3*xn)+scrdata(3*xn+1))/2;
else
   xn=floor(0.25*length(scrdata));
   Q1=scrdata(xn+1);
   Q3=scrdata(3*xn+1);
end
dataHP=Q1-2*iqr(scrdata);
dataLP=Q3+2*iqr(scrdata);
scrdata(find(scrdata<dataHP|scrdata>dataLP))=[];
Avrg=sum(scrdata)/length(scrdata);
