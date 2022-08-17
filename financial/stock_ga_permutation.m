%stock_ga_permutation
function pop=stock_ga_permutation(NVARS,FitnessFcn,options)
totalPopulationSize=sum(options.PopulationSize);
n=NVARS;
pop=cell(totalPopulationSize,1);
for i=1:totalPopulationSize
    pop{i}=rand(n,1);
end