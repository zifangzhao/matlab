close all
%testing script for the ripple detection algorithm
% data=rand(32,10000);
data=LFP(2:end,:);
tp=LFP(1,:);
R=2;                                  %设置分解矩阵的秩 rank
fs=1000;
ep_chn=1; %channel for epoch generation
maviter=500;                                    %最大迭代次数 max iteration
TRange=[30 500]; %ripple time in ms
LFP_event=(data(ep_chn,:));
% step1.1: 5-200Hz LP
% LFP_ep=fft_filter(LFP_event,5,20,fs);
LFP_ep=FilterLFP([tp;LFP_event]','passband', [5 200],'filter','cheby2')';
%step1.2:rectify
LFP_ep=FilterLFP(abs(LFP_ep)','passband',[0 20],'filter','cheby2')';


LFP_ep=LFP_ep(2:end,:);

%step1.3 Z-score
zs=zscore(LFP_ep,[],2);
%step1.4 epoch
ep_raw=zs>3;%prctile(reshape(zs,1,[]),85);
ep_raw=sum(ep_raw(:,:),1);
ep_raw=ep_raw>0;

ep_diff=diff(ep_raw,1,2);
ep_first=find(ep_diff==1,1,'first');
ep_last=find(ep_diff==-1,1,'last');
ep_start=find(ep_diff(ep_first:ep_last)==1)+1+ep_first; %+1 for the fix of diff
ep_end=find(ep_diff(ep_first:ep_last)==-1)+1+ep_first;
ep=[ep_start' ep_end'];
epL=diff(ep,1,2);
ep((epL<TRange(1))|(epL>TRange(2)),:)=[];

%step2.1
fft_len=1000; %1000 points from ripple evokation
% Ripple_fft=zeros(sum(reshape(ep,[],1)),fft_len);
LF=50;
HF=250;
LF_d=LF/fs*fft_len;
HF_d=HF/fs*fft_len;

V=zeros(size(ep,1),length(LF_d:HF_d)*size(LFP_event,1));
for idx_ep=1:size(ep,1)          
    Ripple_fft=(arrayfun(@(x) fft(LFP_event(x,ep(idx_ep,1):ep(idx_ep,2)),fft_len),1:size(LFP_event,1),'UniformOutput',0));
    Ripple_fft=cellfun(@(x) abs(x(LF_d:HF_d)),Ripple_fft,'UniformOutput',0); %segmented fft from [LF-HF]
    V(idx_ep,:)=cell2mat(Ripple_fft);
end

LFP_event_fil=FilterLFP([tp;LFP_event]','passband', [LF HF],'filter','fir1')';
LFP_event_fil=LFP_event_fil(2:end,:);

%step2.2
[i u]=size(V);                                    %计算V的规格

% W=rand(i,R);                            %初始化WH，为非负数
% H=rand(R,u);
% 
% for iter=1:maviter
%     W=W.*((V./(W*H))*H');           %注意这里的三个公式和文中的是对应的
%     W=W./(ones(i,1)*sum(W));    
%     H=H.*(W'*(V./(W*H)));          % No fitness function here
% end
[W,H]=nnmf(V,R,'replicates',10);
%step2.3 SNR evaluation
SNR=zeros(R,size(V,1));
for r=2
    v=W(:,r)*H(r,:);
     SNR(r,:)=1./(sum((v-V).^2,2)./sum(V.^2,2));
end

[maxsnr,n_fac]=max(SNR); %理解为在某一次ripple event中具有比较高的unimodal性质
SelEvent=find(maxsnr>3.5);
Marker=zeros(1,size(data,2));
figure(2)
for idx=1:length(SelEvent)
    Marker(ep(SelEvent(idx),1):ep(SelEvent(idx),2))=1;
    subplot(round(length(SelEvent)^0.5),round(length(SelEvent)^0.5+1),idx);
    plot(LFP_event_fil(:,ep(SelEvent(idx),1):ep(SelEvent(idx),2))');
%     imagesc(LFP_event(:,ep(SelEvent(idx),1):ep(SelEvent(idx),2)))
end

%validation% Ripple detect in FMA toolbox
tm=1/fs*[0:size(LFP_ep,2)-1]';
[ripples,~,~] = FindRipples([tm LFP_ep(1,:)']);
Marker2=zeros(size(Marker));
for idx=1:size(ripples,1)
    Marker2(ripples(idx,1)*fs:ripples(idx,3)*fs)=-1;
end
figure(3);
for idx=1:size(ripples,1)
    
    subplot(round(size(ripples,1)^0.5),round(size(ripples,1)^0.5+1),idx);
    plot(LFP_event_fil(:,ripples(idx,1)*fs:ripples(idx,3)*fs));
%     imagesc(LFP_event(:,ep(SelEvent(idx),1):ep(SelEvent(idx),2)))
end


figure(4);
bar(1:length(Marker),Marker,1);hold on;
bar(1:length(Marker2),Marker2,0.5,'r');
plot(mapminmax(data(2,:),0,1));
hold off



