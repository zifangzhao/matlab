__global__ void stock_accelerate_profit(double * f,double * profit,double * p,int levels,int size1,int size2,int len_p){

int day_idx=threadIdx.x; //day idx
int para_idx=blockIdx.x; //parameter idx different para_estim
int para_idx2=size1;//threadIdx.y; //parameter_calculate data section
int popu_idx=blockIdx.y;

double post=0;

//f[paras+1,paras,day,popu],profit[days,levels],p[paras*levels,popu]
for(int idx=0;idx<levels;idx++){
post=post+profit[day_idx+(size2)*idx]*p[idx+(para_idx+popu_idx*size1)*levels];
}
f[para_idx2+(para_idx+(day_idx+popu_idx*(size2))*size1)*(size1+1)]=post;

//f[para_idx=profit[day_idx+blockDim.x*para_idx]*p[

}