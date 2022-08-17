%stock ga mutation
function mutationChildren=stock_ga_mutation(parents,options,NVARS,FitnessFcn,state,thisScore,thisPopulation,mutationRate)
mutationChildren=cell(length(parents),1);
for i=1:length(parents)
    parent=thisPopulation{parents(i)};
    child=parent;
    switched=randperm(length(child));
    switched=switched(1:ceil(0.1*length(child)));
    child(switched)=child(switched).*(1+randn(size(switched))');
%     child(switched)=child(switched).*(0.9+rand(size(switched))/10);
    mutationChildren{i}=child;
end