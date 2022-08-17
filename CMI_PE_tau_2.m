
function [Dxy,Ixy,Iyx] = CMI_PE_tau2(X,Y,ord,t,Tau)
% 2012-4-25 revised by Zifang Zhao , critical improvement with multiple start points
%  Calculate the different CMI at the different Tau.

%  Input:   X, Y time series;
%           order: order of permuation entropy, ord!*ord!*ord!<N, N is length of series X and Y:
%           t: delay time of permuation entropy, default t=1

%           tau: delay time in conditional mutual information

% Output: 
%           Ixy:  conditional mutual informaion (I(X,Dy|Y)) ;
%           Ixy:  conditional mutual informaion (I(Y,Dy|X)) ;

%           Dxy:  The direcionality of the coupling between the X and Y, X->Y; 
%                     if Out.Dxy > 0, means X->Y, otherwise X<-Y; 
          

%% referrence: Estimating coupling direction between neuronal populations
%% with permutation conditional mutual information, NeuroImage, 2010,52:497-507 

%  revise time: Jan 5 2010, Ouyang,aoxiang, X and Li, Xiaoli 

L=length(Tau);
Dxy=[];
Ixy.Ixy=[];
Ixy.Iyx=[];
Ixy.delay=[];
Iyx.Ixy=[];
Iyx.Iyx=[];
Iyx.delay=[];
% disp(['length of tau=' num2str(Tau)]);
if length(X)>3*length(Tau)+ord
    for stp=1:L   %stp for start point
        X_trim{stp}=X(stp:stp+2*max(Tau+ord));
        Y_trim{stp}=Y(stp:stp+2*max(Tau+ord));
    end
    for stp=1:L
%         parfor i=1:L
%             %     disp(['tau=' num2str(Tau)]);
%             if Tau(i)<ord
%                 TAU=ord;
%                 [~,Ixy_temp(i), Iyx_temp(i)] = CMI_PE(X_trim,Y_trim,ord,t,TAU,L);
%             else
%                 [~,Ixy_temp(i), Iyx_temp(i)] = CMI_PE(X_trim,Y_trim,ord,t,Tau(i),L);
%             end
%         end
        Tau_c=num2cell(Tau); 
        [~,Ixy_temp{stp},Iyx_temp{stp}]=cellfun(@(tau) CMI_PE(X_trim{stp},Y_trim{stp},ord,t,tau,L),Tau_c);
    end
    for stp=1:L
%         Ixy_temp2=cell2mat(Ixy_temp2);
%         Iyx_temp2=cell2mat(Iyx_temp2);
% Ixy_temp-Ixy_temp2
% Iyx_temp-Iyx_temp2
        Ixy.Ixy(stp)=max(Ixy_temp{stp});
        max_idx=find(Ixy_temp{stp}==max(Ixy_temp{stp}));
        Ixy.delay(stp)=max_idx(1);
        Ixy.Iyx(stp)=Iyx_temp{stp}(max_idx(1));
        
        Iyx.Iyx(stp)=max(Iyx_temp{stp});
        max_idx=find(Iyx_temp{stp}==max(Iyx_temp{stp}));
        Iyx.delay(stp)=max_idx(1);
        Iyx.Ixy(stp)=Ixy_temp{stp}(max_idx(1));
    end
end

