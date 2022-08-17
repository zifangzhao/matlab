function SL_sample(data,tim,system_fs,LP,HS,stps,delays,video_enable)
%% scripts for SL presentation
%please load mat file into memory
% data=[elec11';elec12'];
% tim=[500 1000];

% LP=1;
% HS=4;
% system_fs=1000;
res_fs=3*HS;
fs_ratio=res_fs/system_fs;
p_ref=0.05;
n_rec=10;
%% 参数变换
sampling_delay=max(floor(res_fs./HS/3),1);% L
embedding=max(floor(3*HS./LP)+1,1);% m
w1=max(sampling_delay.*(embedding-1),1);% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–11`25中的w1的一半
w2=ceil(n_rec/p_ref)+w1-1;% 文章T. Montez et al. / NeuroImage 33 (2006) 1117–1125中的w2的一半

data_ori=data(tim(1)*system_fs:end,:);
data=resample(data_ori,res_fs,system_fs)';
% stps=1:1;
% delays=1:1;
[SL,synA,synB]=SL_single_test(data_ori(:,1)',data_ori(:,2)',fs_ratio,data(1,:),data(2,:),w1,w2,embedding,sampling_delay,p_ref,stps,delays,res_fs,video_enable);
% figure(2);
% imagesc(SL);axis xy
end

function [SL synA synB]=SL_single_test(data_oriA,data_oriB,fs_ratio,dataA,dataB,w1,w2,embedding,sampling_delay,p_ref,stps,delays,fs,video_enable)
% revised by zifang zhao @ 2012-9-5 修正stp_len的时间判断错误（由length()改为max()）
%%created by Zifang Zhao @ 2012-6-7
%% 参数设置
if nargin<5
    embedding=3;
end
if nargin<6
    sampling_delay=1;
end
if nargin<7
    p_ref=0.05;
end
delay_len=length(delays);
stp_len=length(stps);
SL=nan(delay_len,stp_len);
frm_itp=1;
if video_enable==1
    cnt=0;
    mov(1:length(delays)*length(stps)*frm_itp)=struct('cdata',[],'colormap',[]);
    multiWaitbar('Process',0,'Color',[0.3,0.5,0.7])
end
% h=figure;
h=figure('Renderer','ZBUFFER');
if video_enable==1
    pathname=uigetdir();
end
for dly=delays
    delay=dly;
    data_trim_len= w2+max(stps)+(embedding-1)*sampling_delay+1;
    %     data_trim_len=length(dataA)-delay_len;
    dataA_cal=dataA(1:data_trim_len+1);   %对B进行延时
    dataB_cal=dataB(delay:delay+data_trim_len);
    %     data_len=size(dataA_cal,2);
    if data_trim_len>w2+max(stps)+(embedding-1)*sampling_delay %判断数据长度是否小于可计算的最小长度
        %% 生成向量矩阵
        vecA=zeros(embedding,stp_len+w2);
        vecB=zeros(embedding,stp_len+w2);
        
        for ebd=1:embedding %根据向量维度生成不同时移的矩阵，再进行拼合
            vecA(ebd,:)=dataA_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+max(stps));
            vecB(ebd,:)=dataB_cal(1+(ebd-1)*sampling_delay:(ebd-1)*sampling_delay+w2+max(stps));
        end
        
        %% 计算每一组向量和参考向量间的距离
        %       vref_range=[1+w2:step:cal_len-w2]; %参考向量的计算区间
        vref_range=stps;    %参考向量的计算区间
        %         vec_num=(w2-w1+1); %向量的比较区间
        
        %         vec_R_A=zeros(length(vref_range),vec_num); %初始化距离矩阵
        %         vec_R_B=zeros(length(vref_range),vec_num);
        
        vec_temp_A=cell(1,length(vref_range));
        vec_temp_B=cell(1,length(vref_range));
        
        for ref_idx=1:length(vref_range)
            ref_tim=vref_range(ref_idx);
            %         tim=[ref_tim-w2:ref_tim-w1,ref_tim+w1:ref_tim+w2];  %双侧计算
            tim=ref_tim+w1:ref_tim+w2; %单侧计算
            vec_temp_A{1,ref_idx}=[vecA(:,ref_tim)'; (vecA(:,tim))'];
            vec_temp_B{1,ref_idx}=[vecB(:,ref_tim)'; (vecB(:,tim))'];
        end
        
        vec_R_temp_A=(cellfun(@cal_vec_dist,vec_temp_A,'UniformOutput',0));
        vec_R_temp_B=(cellfun(@cal_vec_dist,vec_temp_B,'UniformOutput',0));
        
        %         for ref_idx=1:length(vref_range)
        %             vec_R_A(ref_idx,:)=vec_R_temp_A{1,ref_idx};
        %             vec_R_B(ref_idx,:)=vec_R_temp_B{1,ref_idx};
        %         end
        
        %% 根据p_ref计算关键距离
        
        vec_R_maxA=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_A,'UniformOutput',0);%找出每一组向量到参考向量的距离中的p_ref位置的距离
        vec_R_maxB=cellfun(@(x) prctile(x,p_ref*100),vec_R_temp_B,'UniformOutput',0);
        
        %% 根据事件的同步性计算SL
        synA=cellfun(@(x,r) x<=r,vec_R_temp_A,vec_R_maxA,'UniformOutput',0);
        synB=cellfun(@(x,r) x<=r,vec_R_temp_B,vec_R_maxB,'UniformOutput',0);
        
        SL(dly,:)=cell2mat(cellfun(@(A,B) mean(A&B)./p_ref,synA,synB,'UniformOutput',0));
        for stp_idx=stps
            sbp=4;
            p_idx=1;
%             subplot(sbp,1,p_idx);p_idx=p_idx+1;
%             plot((1:1+w2)-w1,mapminmax(dataA_cal(stps(stp_idx):stps(stp_idx)+w2),0,1));
%             xlim([1-w1,1+w2-w1]);ylim([0,1.05])
            
            subplot(sbp,1,p_idx);p_idx=p_idx+1;

            plot_dataA=mapminmax(data_oriA(round(stps(stp_idx)/fs_ratio):round((stps(stp_idx)+w2)/fs_ratio)),0,1);
            plot(((0:length(plot_dataA)-1)-w1/fs_ratio)./((fs/fs_ratio)/1000),plot_dataA);

            %             plot(((1:1+w2)-w1)/fs_ratio,mapminmax(data_oriA(round((stps(stp_idx):stps(stp_idx)+w2)/fs_ratio)),0,1));
            xlim([-w1,w2-w1]/fs_ratio);
            ylim([0,1.05])
            %             xlabel('Resampled datapoints');
            set(gca,'Ytick',0:1)
            set(gca,'Xticklabel',[])
            ylabel('amplitude')
            subplot(sbp,1,p_idx);p_idx=p_idx+1;
            %             plot((1:1+w2)-w1,mapminmax(dataB_cal(stps(stp_idx):stps(stp_idx)+w2),0,1),'r');
            %             xlim([1-w1,1+w2-w1]);ylim([0,1.05])
            plot_dataB=mapminmax(data_oriB(round((dly+stps(stp_idx))/fs_ratio):round((dly+w2+stps(stp_idx))/fs_ratio)),0,1);
            plot(((0:length(plot_dataB)-1)-w1/fs_ratio)./((fs/fs_ratio)/1000),plot_dataB,'r');
            xlim([-w1,w2-w1]/fs_ratio);
%             xlim([1,1+w2/(fs/fs_ratio)]);
            %             plot(((1:1+w2)-w1)/fs_ratio,mapminmax(dataB_cal(round((stps(stp_idx):stps(stp_idx)+w2)/fs_ratio)),0,1),'r');
%                         xlim([1-w1,1+w2-w1]/fs_ratio);
            ylim([0,1.05])
            set(gca,'Ytick',0:1)
%             set(gca,'Xticklabel',[])
            ylabel('Normalized ')
            xlabel('time / ms')
            
            
            subplot(sbp,1,p_idx);p_idx=p_idx+1;
            syn_temp=cell2mat(synA(stps(stp_idx)));
            syn_loc=find(syn_temp);
            syn_temp2=zeros(size(syn_temp));
            for idx=1:length(syn_loc)
                if syn_loc(idx)+(embedding-1)*sampling_delay<=length(syn_temp)
                    syn_temp2(syn_loc(idx):syn_loc(idx)+(embedding-1)*sampling_delay)=1;
                else
                    syn_temp2(syn_loc(idx):end)=1;
                end
            end
            len=length(syn_temp);
            scale=((1:len)-1)*sampling_delay./(fs/1000);%.*sampling_delay*embedding;
            plot(scale,mapminmax(vec_R_temp_A{stps(stp_idx)},0,1));hold on;
            bar(scale,syn_temp2.*1.05,1,'linestyle','none');
            alpha(0.5)
            xlim([-w1,w2-w1]*sampling_delay./(fs/1000));
%             xlim([-w1,w2])
%             xlim([1-w1,1+w2-w1]);
            ylim([0,1.05])
            hold off
            set(gca,'Ytick',0:1)
            %         xlim([min(scale),max(scale)]);
            set(gca,'Xticklabel',[])
            ylabel('distance')
            
            subplot(sbp,1,p_idx);p_idx=p_idx+1;
            syn_temp=cell2mat(synB(stps(stp_idx)));
            syn_loc=find(syn_temp);
            syn_temp2=zeros(size(syn_temp));
            for idx=1:length(syn_loc)
                if syn_loc(idx)+(embedding-1)*sampling_delay<=length(syn_temp)
                    syn_temp2(syn_loc(idx):syn_loc(idx)+(embedding-1)*sampling_delay)=1;
                else
                    syn_temp2(syn_loc(idx):end)=1;
                end
            end
            plot(scale,mapminmax(vec_R_temp_B{stps(stp_idx)},0,1),'r');
            
            hold on
            bar(scale,syn_temp2.*1.05,1.0,'r','linestyle','none');
            alpha(0.5)
            xlim([-w1,w2-w1]*sampling_delay./(fs/1000));
%             xlim([-w1,w2]);
%             xlim([1-w1,1+w2-w1]);
            ylim([0,1.05])
            hold off;
            set(gca,'Ytick',0:1)
            ylabel('Normalized')
            xlabel('time / ms')
%             xlabel('Resampled datapoints')
            %         xlim([min(scale),max(scale)]);
            %         subplot(3,1,3)
            %         plot(SL)
            if video_enable==1
                for itp=1:frm_itp
                    cnt=cnt+1;                    
                    mov((stp_idx-1)*length(delays)*frm_itp+(dly-1)*frm_itp+itp)=getframe(h);
                    multiWaitbar('Process',cnt/(length(delays)*length(stps)*frm_itp),'Color',[0.5,0.3,0.3])
                end
            end
        end
    end
end
figure(3)
%             tim_plot=(1:length(dataA_cal))*1000/fs;
subplot(211)
plot(dataA(1:data_trim_len+max(delays)));
ylabel('uV');
set(gca,'Xticklabel',[])
subplot(212)
plot(dataB(1:data_trim_len+max(delays)),'r')
xlabel('Resampled datapoints')
ylabel('uV');


%             mov=reshape(mov,1,[]);
if video_enable==1
    movie2avi(mov,[pathname '\SL_sample'],'compression','None','fps',25);
end
figure(4)
imagesc((stps-1)/fs_ratio,(delays-1)/fs_ratio,SL);axis xy;

multiWaitbar('close all')
end


function vec_dist=cal_vec_dist(vecs) %calculate vector euclidean distance from the first row,there's m * n input and m-1 outputs
Ref=vecs(1,:);
len=size(vecs,1)-1;
if len>0
    Vec=vecs(2:end,:);
    vec_dist=pdist2(Ref,Vec);
else
    vec_dist=nan;
end
end