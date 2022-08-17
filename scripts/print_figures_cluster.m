%script to print figure with matlab cluster
sch=parcluster;
[filename,pathname]=uiputfile('*.eps');
filename=[pathname filename];
jh=[];
for idx=1:1
   xdata=[];
   ydata=[];
   data=[];
   title_text='test';
   
jh=[jh batch(sch,@printfcn,0,{xdata,ydata,data,title_text,filename})];
end
h=waitbar(0,'Processing...');
for idx=1:length(jh)
    wait(jh(idx));
   waitbar(idx/length(jh),h,'Processing');
end
waitbar(idx/length(jh),h,'Finished');

if(isempty(sch.Jobs))
else
    destroy(sch.Jobs);
end