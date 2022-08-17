
__global__ void stock_accelerate_step2(double * score,double * data,double * post,int paras_seg,int paras,int days){

int day_idx=threadIdx.x; //day
//int para_idx=blockIdx.x; //parameters
int popu_idx=blockIdx.y; //population

double sum=0;
double post_temp=0;
double diff=0;
for (int para_idx=0;para_idx<paras;para_idx++){
  post_temp=0;
  for (int idx=0;idx<paras_seg;idx++){
     post_temp=post_temp+post[idx+(para_idx+(day_idx+(popu_idx)*days)*paras)*paras_seg];
   }//post[para_idx1,para_idx,day_idx,popu_idx]
  diff=(post_temp-data[para_idx+day_idx*paras]);
  if(diff<0){
  diff=-diff;
  }
  sum=sum+diff*(day_idx+1);//增加时间权重
}
score[day_idx+popu_idx*days]=sum;
}