%stock ga crossover
function xoverKids=stock_ga_crossover(parents,options,NVARS,FitnessFcn,thisScore,thisPopulation)
nKids=length(parents)/2;
xoverKids=cell(nKids,1);
index=1;

for i=1:nKids
    parent=thisPopulation{parents(2*i-1)};
    
    child=parent;
    p1 = ceil((length(parent) -1) * rand);
    p2 = p1 + ceil((length(parent) - p1- 1) * rand);
    parent2=thisPopulation{parents(2*i)};
    child(p1:p2)=parent2(p1:p2);
    xoverKids{i}=child;
end