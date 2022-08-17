% Formalin Rate Plot Extreme Value Exclusion
% Pickdata as a matrix with timeline in a row and trials across rows
% by Xuezhu Li  2012-3-19

function[ExValues]=value_exclude(pickdata)
%%
Avrgdata=sum(pickdata,2)./size(pickdata,2);
[scrdata,index]=sort(Avrgdata);
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
ExSpot=find(scrdata<dataHP|scrdata>dataLP);
pickdata(index(ExSpot),:)=[];
ExValues=pickdata;
%%
% for i=5:size(ExValues,2)
%     [scrdata2,index2]=sort(ExValues(:,i));
%     
%     if mod(0.25*length(scrdata2),1)==0;
%         xn=0.25*length(scrdata2);
%         Q1=(scrdata2(xn)+scrdata2(xn+1))/2;
%         Q3=(scrdata2(3*xn)+scrdata2(3*xn+1))/2;
%     else
%         xn=floor(0.25*length(scrdata2));
%         Q1=scrdata2(xn+1);
%         Q3=scrdata2(3*xn+1);
%     end
%     dataHP2=Q1-2*iqr(scrdata2);
%     dataLP2=Q3+2*iqr(scrdata2);
%     ExSpot2=find(scrdata2<dataHP2|scrdata2>dataLP2);
%     pickdata(index2(ExSpot2),:)=[];
%     ExSpot2=[];
% end
end


