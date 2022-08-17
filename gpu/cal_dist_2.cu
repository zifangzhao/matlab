
__global__ void cal_dist_2(double * dist,double * vecs,int * vref,int * tim_range,int embedding)
{

int tim_idx=threadIdx.x; //vecs location
//int tim_idx=blockIdx.y; //tim_range
//int tim_idx=gridDim.x; //tim_range
int ref_idx=blockIdx.y;//startpoint


int ebd;
int tim;
int refe;

double temp=0;
double len=0;

refe=vref[ref_idx]-1;   //matlab索引从1开始，c从0开始
tim=refe+tim_range[tim_idx];  //tim_range=w1:w2;

for(ebd=0;ebd<embedding;ebd++){
    len=vecs[tim*embedding+ebd]-vecs[refe*embedding+ebd];
    temp+=len*len;
}
dist[ref_idx+tim_idx*gridDim.y]=sqrt(temp);
}