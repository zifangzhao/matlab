%stock_ga_permutation
function pop=stock_ga_create(NVARS,FitnessFcn,options,data)
totalPopulationSize=sum(options.PopulationSize);
n=NVARS;
pop=cell(totalPopulationSize,1);
data_mean=mean(reshape(data,1,[]));
for i=1:totalPopulationSize
    pop{i}=rand(n,1)*data_mean/n*6*3;
end