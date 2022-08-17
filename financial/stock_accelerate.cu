__global__ void stock_accelerate(double * f,double * data,double * p,int fft_day,int size1,int size2,int len_p){
//计算出的f为post拟合值，为[paras1,paras2,days,popu]矩阵，其中每天的每种类型的数据预测值为paras1相加
int day_idx=threadIdx.x; //day idx
int para_idx=blockIdx.x; //parameter idx different para_estim
int para_idx2=threadIdx.y; //parameter_calculate data section
int popu_idx=blockIdx.y;
double temp=0;
double sum=0;
double post=0;


for(int idx=0;idx<fft_day;idx++){
    temp=data[para_idx2+(idx+day_idx)*size1];
    post=post+temp*p[(len_p/size1)*para_idx+idx*size1+para_idx2+popu_idx*len_p];
    sum=sum+temp;
}
post=post+(sum/fft_day)*p[(len_p/size1)*para_idx+fft_day*size1+para_idx2+popu_idx*len_p];
f[para_idx2+(para_idx+(day_idx+popu_idx*(size2-fft_day))*size1)*size1]=post;
//f[0]=1;
//f[1]=2;
//f[2]=3;

//f[para_idx2+para_idx*size1+day_idx*size1*size1]=fabs(post-data[para_idx+(day_idx+fft_day+1)
//*size1]);

}