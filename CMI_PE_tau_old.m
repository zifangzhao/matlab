
function [Dxy,Ixy,Iyx] = CMI_PE_tau_old(X,Y,ord,t,Tau)

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
% disp(['length of tau=' num2str(Tau)]);
parfor i=1:L
%     disp(['tau=' num2str(Tau)]);
    if Tau(i)<ord
        TAU=ord;
        [Dxy(i),Ixy(i), Iyx(i)] = CMI_PE(X,Y,ord,t,TAU,L);
    else
        [Dxy(i),Ixy(i), Iyx(i)] = CMI_PE(X,Y,ord,t,Tau(i),L);
    end
end


