function SL=SL_multidelay(data,channel_delay,w1,w2,embedding,sampling_delay,p_ref,step)
%% created by Zifang Zhao @ 2012-6-5 
%% 参数设置
n_rec=round(p_ref.*(w2-w1+1));  %最小重现次数，由向量个数和重现事件概率决定
if nargin<5
    embedding=3;
end
if nargin<6
    sampling_delay=1;
end
if nargin<7
    p_ref=0.05;
end
if nargin<8
    step=1;
end

s=1;timedelay=1;

[channel_num, data_len]=size(data);
cal_len=data_len-(embedding-1)*sampling_delay;

%% 生成向量矩阵
vec=zeros(channel_num,embedding,cal_len);
for ebd=1:embedding %根据向量维度生成不同时移的矩阵，再进行拼合
    temp=circshift(data,[0 -(ebd-1).*sampling_delay]);
    vec(:,ebd,:)=temp(:,1:cal_len);
end

%% 计算每一组向量和参考向量间的距离
vref_range=[1+w2:step:cal_len-w2]; %参考向量的计算区间
vec_num=2*(w2-w1+1); %向量的比较区间
vec_R=zeros(channel_num,length(vref_range),vec_num); %初始化距离矩阵

vec_temp=cell(channel_num,length(vref_range));
for channel=1:channel_num
    for ref_idx=1:length(vref_range)
        ref_tim=vref_range(ref_idx);
        tim=[ref_tim-w2:ref_tim-w1,ref_tim+w1:ref_tim+w2];
        vec_temp{channel,ref_idx}=[vec(channel,:,ref_tim); squeeze(vec(channel,:,tim))'];
    end
end

vec_R_temp=(cellfun(@cal_vec_dist,vec_temp,'UniformOutput',0));
for channel=1:channel_num
    for ref_idx=1:length(vref_range)
        vec_R(channel,ref_idx,:)=vec_R_temp{channel,ref_idx};
    end
end
end

function vec_dist=cal_vec_dist(vecs) %calculate vector euclidean distance from the first row,there's m * n input and m-1 outputs
vec_dist=pdist(vecs);
vec_dist=vec_dist(1:size(vecs,1)-1);
end
