function fname=fnamegenerator(name,xls)
filename=name;
fieldname=fieldnames(xls);
fname=[filename(1:end-4) '_' fieldname(beh) '.mat'];