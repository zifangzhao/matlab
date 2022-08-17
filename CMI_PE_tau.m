
function [Delay,Ixy,Iyx,DP] = CMI_PE_tau(X,Y,system_fs,ord,t,Tau,stps)

%  Calculate the different CMI at the different Tau.

%  Input:   X, Y time series;
%           order: order of permuation entropy, ord!*ord!*ord!<N, N is length of series X and Y:
%           t: delay time of permuation entropy, default t=1

%           tau: delay time in conditional mutual information
%           stps: start points of PCMI analysis
% Output: 
%           Ixy:  conditional mutual informaion (I(X,Dy|Y)) ;
%           Ixy:  conditional mutual informaion (I(Y,Dy|X)) ;

%           Dxy:  The direcionality of the coupling between the X and Y, X->Y; 
%                     if Out.Dxy > 0, means X->Y, otherwise X<-Y; 
          

%% referrence: Estimating coupling direction between neuronal populations
%% with permutation conditional mutual information, NeuroImage, 2010,52:497-507 
% 2012-5-24 revised by Zifang Zhao ,added Delay for 5-24 version of CMI_PE
% 2012-5-6 revised by Zifang Zhao , 改进对多起点数据的存储为存储每一次的数据
% 2012-4-25 revised by Zifang Zhao , improvement with multiple start points
%  revise time: Jan 5 2010, Ouyang,aoxiang, X and Li, Xiaoli 
Lstp=length(stps);
L=length(Tau);
DP=[];
Ixy=[];
Iyx=[];
Delay=[];

X_trim=cell(1,Lstp);
Y_trim=cell(1,Lstp);
Delay_temp=cell(1,Lstp);
% disp(['length of tau=' num2str(Tau)]);
DP_temp=cell(1,Lstp);
Ixy_temp=cell(1,Lstp);
Iyx_temp=cell(1,Lstp);
Delay_temp=cell(1,Lstp);
if length(X)>3*max(Tau+ord)
    for stp=1:Lstp   %stp for start point
        X_trim{stp}=X(stp:stp+2*max(Tau+ord));
        Y_trim{stp}=Y(stp:stp+2*max(Tau+ord));
    end
    parfor stp=1:Lstp
        Tau_c=num2cell(Tau); 
        [DP_temp{stp},Ixy_temp{stp},Iyx_temp{stp}]=cellfun(@(tau) CMI_PE(X_trim{stp},Y_trim{stp},ord,t,tau,L),Tau_c);
        Delay_temp{stp}=(stp+(1:length(Ixy_temp{stp}))).*(1000/system_fs);
    end
    Ixy=cell2mat(reshape(Ixy_temp,Lstp,[]));
    Iyx=cell2mat(reshape(Iyx_temp,Lstp,[]));
    DP=cell2mat(reshape(DP_temp,Lstp,[]));
    Delay=cell2mat(reshape(Delay_temp,Lstp,[]));
%     Dxy=Ixy
% 2012.4.26 old version with locating max value location______________________________
%     for stp=1:L
%         Ixy_temp2=cell2mat(Ixy_temp2);
%         Iyx_temp2=cell2mat(Iyx_temp2);
% Ixy_temp-Ixy_temp2
% Iyx_temp-Iyx_temp2

%         Ixy.Ixy(stp)=max(Ixy_temp{stp});
%         max_idx=find(Ixy_temp{stp}==max(Ixy_temp{stp}));
%         Ixy.delay(stp)=max_idx(1);
%         Ixy.Iyx(stp)=Iyx_temp{stp}(max_idx(1));
%         
%         Iyx.Iyx(stp)=max(Iyx_temp{stp});
%         max_idx=find(Iyx_temp{stp}==max(Iyx_temp{stp}));
%         Iyx.delay(stp)=max_idx(1);
%         Iyx.Ixy(stp)=Ixy_temp{stp}(max_idx(1));  
% end
%--------------------------------------------------------

end

