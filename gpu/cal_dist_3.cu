
__global__ void cal_dist_3(double * dist,double * vecs,int * vref,int * tim_range,int embedding)
{

int tim_idx=threadIdx.x; //vecs location,对每一个向量求距离
//int tim_idx=blockIdx.y; //tim_range
//int tim_idx=gridDim.x; //tim_range
int ref_idx=blockIdx.y;//startpoint,相当于移动的ref

extern __shared__ float vecs_shared[];
//__shared__ float vecs_ref_shared[blockDim.x];
int ebd;
int tim;
int refe;

double temp=0;
double len=0;

refe=vref[ref_idx]-1;   //matlab索引从1开始，c从0开始
tim=refe+tim_range[tim_idx];  //tim_range=w1:w2;



for(ebd=0;ebd<embedding;ebd++){
    vecs_shared[tim_idx*embedding+ebd]=vecs[tim*embedding+ebd];

    len=vecs_shared[tim_idx*embedding+ebd]-vecs[refe*embedding+ebd];
    temp+=len*len;
}
dist[ref_idx+tim_idx*gridDim.y]=sqrt(temp);
}