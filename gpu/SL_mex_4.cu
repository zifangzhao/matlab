# pragma warning (disable:4819)
#include "mex.h"
// #include "cuda.h"
// #include "cuda_runtime.h"
#include "gpu/mxGPUArray.h"
#define BlockSize 1024
#define NPRCMAX 1000

//Device code 1 for single channel distance calculation
void __global__ CalDistance(double * dist,const double * rawdata,int N_data,int Nchn,const double * vref,const double * tim_range, int embedding,int sampling_delay,int Nvec,int Nstep){
/*���ڵõ�������Ϊһ��ʱ��������Ĳ���
 *���ݲ�ͬ��step��window��С���ж���Ҫ�����thread����
 *һ��step��Ҫ����w2-w1��������distance,��ͬһͨ���ڷ�Ϊstep��������channel���Ի�����block��
 *
 */

int t_idx=threadIdx.x; //this is the vector idx plus step idx
int b_idx=blockIdx.x;// the number of single channel's block idx
int chn_idx=blockIdx.y;//this is the channel idx

int tim_idx;//keep the same with cal_dist_3
int ref_idx;  //startpoint

// extern __shared__ double shared_data[]; //should be size of single channel rawdata;

//filling up the shared memory, this should have nothing to do with b_idx
int temp_idx=t_idx; // this is for filling the shared memory
// int t;
// while(temp_idx<N_data){
// //      t=rawdata[chn_idx+temp_idx*Nchn];
//     shared_data[temp_idx]=rawdata[chn_idx+temp_idx*Nchn]; //��1��channel�����ݷ��䵽�����ڴ���,all thread is involved to acceletate
//     temp_idx+=BlockSize;
//     
// }
// __syncthreads();
//Data transfer complete,data now transferd to shared memory

//get the actural cordinate  by tim_idx and ref_idx
temp_idx=t_idx+b_idx*BlockSize; //get the current abs cord.
if(temp_idx<Nvec*Nstep){ //��Ϊtheradsperblock�ǹ̶��ģ���˻����߳̿鲢��������ڼ��㣬ֻ���빲���ڴ����
    ref_idx=(int) temp_idx/(Nvec);//stp
    tim_idx=temp_idx % (Nvec);//vec_idx
// //------------------------------calculating the distance---------------------------------
    int tim;
    int refe;
    double temp=0;
    double len=0;
    
//�����������������ԭʼ�����еľ�������
    refe=vref[ref_idx];   //matlab������1��ʼ��c��0��ʼ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    tim=refe+tim_range[tim_idx];  //tim_range=w1:w2;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    for(int ebd=0;ebd<embedding;ebd++){
        len=rawdata[chn_idx+(refe+ebd*sampling_delay)*Nchn]-rawdata[chn_idx+(tim+ebd*sampling_delay)*Nchn];
        temp+=len*len;
//         temp=shared_data[N_data-1];//shared data OK!
//         temp=tim;//201-202????
    }
//     if(t_idx+b_idx*BlockSize<N_data){
//     dist[t_idx+b_idx*BlockSize]=shared_data[t_idx+b_idx*BlockSize];
//     }
    dist[ref_idx+tim_idx*Nstep+chn_idx*Nvec*Nstep]=temp;//shared memory would work through block
}
}
void __device__ gpu_sort(double *min_num,double add_num,int N_small){ //pick up smallest N_small values
//     int *temp=new temp[N_small+1];
    double max_v=add_num;
    double temp;
    
    
    for(int i=0;i<N_small;i++){
        if(min_num[i]>max_v){
            temp=min_num[i];
            min_num[i]=max_v;
            max_v=temp;
        }
    }    
}
double __device__ gpu_max(double * data, int N){
    double max_v=data[0];
    for(int i=1;i<N;i++){
        if(data[i]>max_v){
            max_v=data[i];
        }
    }
    return max_v;
}

void __global__ GPUprctile(double * dist,double * cdist,int N_small,int Nstep,int Nvec){
    int idx_stepA=threadIdx.x;
    int idx_stepB=blockIdx.x;
    int chn_idx=blockIdx.y;
    int stp_idx=idx_stepA+BlockSize*idx_stepB;
   double min_num[NPRCMAX];
   for(int i=0;i<N_small;i++){
       min_num[i]=1.79769e+308;
   }
    if(stp_idx<Nstep){
        for(int i=0;i<Nvec;i++){
            gpu_sort(min_num,dist[stp_idx+i*Nstep+chn_idx*Nvec*Nstep],N_small);
        }
        cdist[stp_idx+chn_idx*Nstep]=gpu_max(min_num,N_small);
    }
    __syncthreads();
    
}

/*---------------------------------------Convert distace into pattern-------------*/
void __global__ CalPattern(int * pattern, double * dist,double * cdist,int Nvec,int Nstep){
//-----------------------calculating pattern---------------------------
    int t_idx=threadIdx.x; //this is the vector idx plus step idx
    int b_idx=blockIdx.x;// the number of single channel's block idx
    int chn_idx=blockIdx.y;//this is the channel idx
    
    int tim_idx;//keep the same with cal_dist_3
    int ref_idx;

    int temp_idx=t_idx+b_idx*BlockSize; // get the current abs cord.
    if(temp_idx<Nvec*Nstep){
        ref_idx=(int) temp_idx/Nvec; //stp
        tim_idx=temp_idx % Nvec;//vec_idx
        
        pattern[ref_idx+tim_idx*Nstep+chn_idx*Nvec*Nstep]=(dist[ref_idx+tim_idx*Nstep+chn_idx*Nvec*Nstep]<=cdist[ref_idx+chn_idx*Nstep]);
    }
}
/*---------------------------------------Convert pattern into SL matrix-------------*/
void __global__ SLGen(double * SL, int * pattern,const double * vref,double Nvec,double Nstep,double Nchn,double Nstart){
    int tim_idx=threadIdx.x; //vecs location,this can not be longer than 1024
//     int step_idx=blockIdx.y; //���idx��startpoint��delay�Ļ��һά����Ҫ����
    int stp=blockIdx.y;
    int dly=blockIdx.z;
    int chn=blockIdx.x;// channel number A
//     int y=blockIdx.y;// channel number B
    int x=chn/(int)Nchn;
    int y=chn%(int)Nchn;
    int synE=0;
    int allE=0;
    __shared__ int syn[2*BlockSize+1]; //��Ҫ����ʼ���Ƿ�Ϊ0
    
//     int dly=step_idx/(int)Nstart;
//     int stp=step_idx%(int)Nstart;
    int A=pattern[(int)(stp+tim_idx*Nstep+x*Nvec*Nstep)];
    int B=pattern[(int)((stp+dly)+tim_idx*Nstep+y*Nvec*Nstep)];
//     int B=pattern[(int)(tim_idx+(stp+dly)*Nvec+y*Nvec*Nstep)];
    syn[2*tim_idx]=A&B;
    syn[1+2*tim_idx]=A+B;
    __syncthreads();
    if(tim_idx==0){
        for(int idx=0;idx<Nvec;idx++){
        synE+=syn[2*idx];
        allE   +=syn[1+2*idx];
        }
        if(allE!=0){
            SL[(int)(x+y*Nchn+stp*Nchn*Nchn+dly*Nstart*Nchn*Nchn)]=2*((double) synE/ (double) allE);
        }
        else{
            SL[(int)(x+y*Nchn+stp*Nchn*Nchn+dly*Nstart*Nchn*Nchn)]=0;
        }
    }
    __syncthreads();
}
/*
 * Host code----------------------------------------------MAIN FUNCTION--------------------------------------------
 -----------------------------------------------------------------------------------------------------------------------*/
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,mxArray const * prhs[]){
    //(rawdata,w1,w2,embedding,sampling_delay,p_ref,stps,delays)
    //plhs=output,need mxCreateDoubleMatrix to assign the space
    
    int const threadsPerBlock=BlockSize;
    
     /* Declare all variables.*/
    mxGPUArray const *rawdata; 
    mxGPUArray * dist;
    mxGPUArray * pattern;
    mxGPUArray * SL;
    mxGPUArray * cdist;
    mxGPUArray const * GVref;
    mxGPUArray const * Gtim;
//     mxGPUArray * min_num;
    
    mxArray * vref;
    mxArray * tim;
    mxArray * para;
//     mxArray * ref_out;
//     mxArray * tim_out;
//     mxArray * stp_out;
    double * p_vref;
    double * p_tim;
    
    double const * p_rawdata;
    double * p_dist; 
    int * p_pattern;
    double * p_SL;
    double * p_cdist;
    double const * p_GVref;
    double const * p_Gtim;
//     double * p_min_num;
    
    int Nchn;
    int Datalen;
    int Nvec;
    int Nstep;
    
//     char const * const errId = "parallel:gpu:mexGPUExample:InvalidInput";
//     char const * const errMsg = "Invalid input to MEX file.";
    
    //initialize the MATLAB gpu API
    mxInitGPU();
    /*--------------------------------testing input parameters-----------------------------*/
    /* Throw an error if the input is not a GPU array. */
//     if ((nrhs!=8) || !(mxIsGPUArray(prhs[0]))) {
//         mexErrMsgIdAndTxt(errId, errMsg);
//     }
    /*--------------------------------Creating mex vars----------------------------*/
    //(rawdata,w1,w2,embedding,sampling_delay,p_ref,stps,delays)
    Nchn=mxGetM(prhs[0]);
    Datalen=mxGetN(prhs[0]);
    rawdata=mxGPUCreateFromMxArray(prhs[0]); /*Create read-only mxGPUArray object from input mxArray
     * ???????????????????const��ԭ��
     *data transfered to GPUarray*/
    p_rawdata=(double const *)(mxGPUGetDataReadOnly(rawdata));//Read-only raw pointer to underlying data
   
    double w1=mxGetScalar(prhs[1]);
    double w2=mxGetScalar(prhs[2]);
    double embedding=mxGetScalar(prhs[3]);
    double sampling_delay=mxGetScalar(prhs[4]);
    double p_ref=mxGetScalar(prhs[5]);
    double * stps=mxGetPr(prhs[6]);
    double * delays=mxGetPr(prhs[7]);
    int Nstart=mxGetN(prhs[6]);
    int Ndelay=mxGetN(prhs[7]);
    Nvec=(int) (w2-w1-(embedding-1)*sampling_delay+1)*2/sampling_delay;
    Nstep=Nstart+Ndelay;
    int N_small=Nvec*p_ref;
    int temp_size[]={Nchn*Nvec*Nstep};
        /* Create a GPUArray to hold the result and get its underlying pointer. */               
    
    dist=mxGPUCreateGPUArray(1,
            (const mwSize *)temp_size,//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!��һ����ȷ
            mxDOUBLE_CLASS,
            mxREAL,
            MX_GPU_INITIALIZE_VALUES); //���һ�о����Ƿ��ʼ��
    p_dist=(double * )mxGPUGetData(dist); //???????????????Ϊʲô��Ҫǿ��ת������
    pattern=mxGPUCreateGPUArray(1,
            (const mwSize *)temp_size,
            mxINT32_CLASS, //_________________________________________caution
            mxREAL,
            MX_GPU_INITIALIZE_VALUES); //���һ�о����Ƿ��ʼ��
    p_pattern=(int * )mxGPUGetData(pattern);
    temp_size[0]=Nchn*Nchn*Nstart*Ndelay;
    SL=mxGPUCreateGPUArray(1,
            (const mwSize *)temp_size,
            mxDOUBLE_CLASS,
            mxREAL,
            MX_GPU_INITIALIZE_VALUES); //���һ�о����Ƿ��ʼ��
    p_SL=(double * )mxGPUGetData(SL);
    temp_size[0]=Nchn*Nstep;
    cdist=mxGPUCreateGPUArray(1,
            (const mwSize *)temp_size,//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!��һ����ȷ
            mxDOUBLE_CLASS,
            mxREAL,
            MX_GPU_INITIALIZE_VALUES); //���һ�о����Ƿ��ʼ��
    p_cdist=(double * )mxGPUGetData(cdist); 
//     temp_size[0]=N_small;
//     min_num=mxGPUCreateGPUArray(1,
//              (const mwSize *)temp_size,//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!��һ����ȷ
//             mxDOUBLE_CLASS,
//             mxREAL,
//             MX_GPU_INITIALIZE_VALUES); //���һ�о����Ƿ��ʼ��
//     p_min_num=(double * )mxGPUGetData(min_num); 
            

    
    /*--------------------------------establish output variables---------------------------*/
    plhs[0]=mxCreateCellMatrix(1,1);
    //nlhs doesn't count?
    
    /*--------------------------------main program--------------------------------------*/
    int blocksPerGrid=Nchn*(1+Nvec*Nstep/threadsPerBlock);
    

    
    int tim_size=2*(w2-w1-(embedding-1)*sampling_delay+1);
    vref=mxCreateDoubleMatrix(Nstep,1,mxREAL);
    tim=mxCreateDoubleMatrix(tim_size,1,mxREAL);
    p_vref=mxGetPr(vref);
    p_tim=mxGetPr(tim);
    
    
    //������Ҫ�����ʵ����Ҫ��step,������stp��dly���Ǵ�0��ʼ�����Ҳ���һ����stps����>1
    int inc=stps[1]-stps[0];
    for(int idx=0;idx<Nstep;idx++){
        p_vref[idx]=inc*(idx+stps[0])+w2;//location of Ref vector, should be stps+w2
    }
    
    for(int idx=0;idx<tim_size;idx++){ //[-w2:-w1-ebd-1)*sampling_delay,w1:w2-(ebd-1)*sampling_delay
        if(idx<tim_size/2){
            p_tim[idx]=idx-w2;
//             p_tim[idx]=idx*sampling_delay-w2;
        }
        else{
            p_tim[idx]=w1+idx-tim_size/2;
//             p_tim[idx]=w1+idx*sampling_delay-tim_size/2;
        }
    }
    
    
//     int *vref=new int[Nstart];
//     for(int idx=0;idx<Nstart;idx++){
//         vref[idx]=stps[idx]+w2;
//     }
//     int *tim=new int[tim_size];
//     for(int idx=0;idx<tim_size;idx++){
//         if(idx<tim_size/2){
//             tim[idx]=idx-w2;
//         }
//         else{
//             tim[idx]=idx+2*w1+(embedding-1)*sampling_delay;
//         }
//     }
    
    GVref=mxGPUCreateFromMxArray(vref);
    Gtim=mxGPUCreateFromMxArray(tim);
    p_GVref=(double const *)(mxGPUGetDataReadOnly(GVref));
    p_Gtim=(double const *)(mxGPUGetDataReadOnly(Gtim));
    
//     p_GVref=(double * )mxGPUGetData(GVref); 
//     p_Gtim=(double * )mxGPUGetData(Gtim); 
    
    dim3 blocks(1+Nvec*Nstep/threadsPerBlock,Nchn);
//    CalDistance<<<blocks,threadsPerBlock,Datalen*sizeof(double)>>>(p_dist,p_rawdata,Datalen,Nchn,p_GVref,p_Gtim,(int) embedding,(int) sampling_delay,Nvec,Nstep);
   CalDistance<<<blocks,threadsPerBlock>>>(p_dist,p_rawdata,Datalen,Nchn,p_GVref,p_Gtim,(int) embedding,(int) sampling_delay,Nvec,Nstep);
   mxGPUDestroyGPUArray(rawdata);
   
   
   dim3 blocks_C(1+Nstep/threadsPerBlock,Nchn);
   GPUprctile<<<blocks_C,threadsPerBlock>>>(p_dist,p_cdist,N_small,Nstep,Nvec); 
   //calculate the critical distance in CPU
   
   CalPattern<<<blocks,threadsPerBlock>>>(p_pattern,p_dist,p_cdist,Nvec,Nstep);
   mxGPUDestroyGPUArray(dist);
   mxGPUDestroyGPUArray(cdist);
   
   dim3 blocks_SL(Nchn*Nchn,Nstart,Ndelay);
   SLGen<<<blocks_SL,Nvec>>>(p_SL,p_pattern,p_GVref,Nvec,Nstep,Nchn,Nstart);
   mxGPUDestroyGPUArray(pattern);
    //dist[ref_idx+tim_idx*Nvec+chn_idx*Nvec*Nstep]
    //pattern[ref_idx+tim_idx*Nvec+chn_idx*Nvec*Nstep]
    //SL[x+y*Nchn]
    
    //convert the SL into CELL

    para=mxCreateDoubleMatrix(6,1,mxREAL);//����һ��Ƭ�ڴ棬�ṩָ���ַ��ָ��
//     ref_out=mxCreateDoubleMatrix(Nstart,1,mxREAL);
//     tim_out=mxCreateDoubleMatrix(tim_size,1,mxREAL);
//     stp_out=mxCreateDoubleMatrix(Nstart,1,mxREAL);
    double * para_C=mxGetPr(para);
//     double * para_CR=mxGetPr(ref_out);
//     double * para_CT=mxGetPr(tim_out);
//     double * para_stp=mxGetPr(stp_out);
    double temp[]={Datalen,Nchn,temp_size[0],tim_size,blocksPerGrid,threadsPerBlock};
//     para_C[0]=Datalen;
//     para_C[1]=Nchn;
//     para_C[2]=embedding;
//     para_C[3]=sampling_delay;
//     para_C[4]=Nvec;
//     para_C[5]=Nstep;
    memcpy(para_C,temp,sizeof(temp));

//     memcpy(para_CR,p_vref,Nstep*sizeof(double));
//     memcpy(para_CT,p_tim,tim_size*sizeof(double));
//     memcpy(para_stp,stps,Nstart*sizeof(double));
    

    mxSetCell(plhs[0],0,mxGPUCreateMxArrayOnCPU(SL));  //testing by output to 1
//     mxSetCell(plhs[0],1,mxGPUCreateMxArrayOnCPU(rawdata));  //testing by output to 1
//     mxSetCell(plhs[0],2,para);
//     mxSetCell(plhs[0],3,vref);
//     mxSetCell(plhs[0],4,tim);
//     mxSetCell(plhs[0],3,ref_out);
//     mxSetCell(plhs[0],4,tim_out);
//     mxSetCell(plhs[0],5,mxGPUCreateMxArrayOnCPU(dist));  //testing by output to 1
//     mxSetCell(plhs[0],6,mxGPUCreateMxArrayOnCPU(cdist));  //testing by output to 1
//     mxSetCell(plhs[0],7,mxGPUCreateMxArrayOnCPU(pattern));  //testing by output to 1
    
//     mxSetCell(plhs[0],8,stp_out);
  //  mxArray * SL_CPU=mxGPUCreateMxArrayOnCPU(SL);
    //mxArray * SL_each=mxCreateDoubleMatrix(Nstart,Ndelay,mxREAL);
//     double * p_SL_each=mxGetPr(SL_each);
//     double * p_SL_CPU=mxGetPr(SL_CPU);
//     for(int A=0;A<Nchn;A++){
//         for(int B=0;B<Nchn;B++){
//             for(int x=0;x<Nstart;x++){
//                 for(int y=0;y<Ndelay;y++){
//                     p_SL_each[x+y*Nstart]=p_SL_CPU[A+B*Nchn+x*Nchn*Nchn+y*Nchn*Nchn*Nstart];
//                 }
//             }
//             mxSetCell(plhs[0],8+A+B*Nchn,SL_each);
//         }        
//     }

    
    /*--------------------------------release resource------------------------------------*/
//     delete[] vref;
//     delete[] tim;
//     mxGPUDestroyGPUArray(dist);
//     mxGPUDestroyGPUArray(pattern);
    mxGPUDestroyGPUArray(SL);
//     mxGPUDestroyGPUArray(rawdata);    
//     mxGPUDestroyGPUArray(cdist);
    
//     mxDestroyArray(vref);
//     mxDestroyArray(tim);
//     mxDestroyArray(para);
//     mxDestroyArray(ref_out);
//     mxDestroyArray(tim_out);
//     mxDestroyArray(stp_out);

//     mxGPUDestroyGPUArray(min_num);    

    mxGPUDestroyGPUArray(GVref);    
    mxGPUDestroyGPUArray(Gtim);    
//     cudaDeviceReset();
    return;
}