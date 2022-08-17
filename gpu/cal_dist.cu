
__global__ void cal_dist(double * dist,double * vecs,int embedding)
{

int idx=blockIdx.x * blockDim.x +threadIdx.x;
int i;
double temp=0;

for(i=0;i<embedding;i++){
    temp+=vecs[idx+i]*vecs[idx+i];
}
dist[idx]=sqrt(temp);
}