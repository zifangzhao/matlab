data=(randi(100,[2e3 2e2]));
sort(data,2);
G=gpuArray(data);
sort(G,2);