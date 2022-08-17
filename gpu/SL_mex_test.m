%%rigious test for SL_mex
clear
Nchn=2;
data_len=1000;
data_test=rand(Nchn,data_len);
system_fs=100;
sig_len=30;
sig_latency=100;
sig_freq=25;
HS=50;
LP=20;
p_ref=0.05;
n_rec=10;

sampling_delay=ceil(system_fs./HS/3);% L
embedding=ceil(3*HS./LP);% m
w1=sampling_delay.*(embedding-1);
w2=ceil((n_rec/p_ref+2*w1-1)/2);
Nvec=(w2-w1-(embedding-1)*sampling_delay+1)*2;


stps=0:1:500    ;
delays=0:1:20;
Nstep=length(stps)+length(delays);
ref=zeros(Nstep,1);
tim=zeros(Nvec,1);
for idx=0:Nstep-1
ref(idx+1)=(stps(1)+idx)*(stps(2)-stps(1))-w2;
end
for idx=0:Nvec-1
    if idx<Nvec/2
        tim(idx+1)=idx*sampling_delay-w2;
    else
        tim(idx+1)=w1+idx*sampling_delay-Nvec/2;
    end
end
% for idx=0:
for idx=1:Nchn
    loc=w2+(idx-1)*sig_latency;
    idx_sin=(0:(sig_len-1))./system_fs;
    data_test(idx,loc:loc+sig_len-1)=sin(2*pi*sig_freq*idx_sin);
end

% for idx=1:Nchn
%     loc=w2+(Nchn-idx+1)*sig_latency;
%     idx_sin=0:(sig_len-1)./system_fs;
%     data_test(idx,loc:loc+sig_len)=cos(2*pi*sig_freq*idx_sin);
% end


% stp_current=1;
% stp_seg=round(4e8/(Nchn^2*size(data_test,2)));
% cycle=ceil(length(stps)/stp_seg);
SL_3=cell(Nchn);
% stps_now=cell(cycle,1);
% for cyc=1:cycle
%     if stp_current+stp_seg<length(stps)
%         stps_now{cyc}=stps(stp_current:stp_current+stp_seg-1);
%         stp_current=stp_current+stp_seg;
%     else
%         stps_now{cyc}=stps(stp_current:end);
%         stp_current=stp_current+stp_seg;
%     end
% end
% SL=cellfun(@(x) SL_mex(data_test,w1,w2,embedding,sampling_delay,p_ref,x,delays),stps_now,'UniformOutput',0);
    SL_m=SL_mex(data_test,w1,w2,embedding,sampling_delay,p_ref,stps,delays); %%%THIS METHOD MUST HAVE A DELAY STARTING FROM 0!
    SL_m2=reshape(SL_m,size(data_test,1),size(data_test,1),length(stps),length(delays));
    %%
    cyc=1;
    for A=1:Nchn
        for B=1:Nchn
            temp=squeeze(SL_m2(A,B,:,:))';
            if cyc==1
                SL_3{A,B}=temp;
            else
                SL_3{A,B}=[SL_3{A,B} temp];
            end
                    subplot(Nchn,Nchn,A+(B-1)*Nchn);
                    imagesc(temp);
        end
    end

