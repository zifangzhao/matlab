
function [Dxy,Ixy,Iyx] = CMI_PE_gpu(X,Y,ord,t,tau)

%  Input:   X, Y time series;
%           order: order of permuation entropy,  ord!*ord!*ord!<N, N is length of series X and Y:
%           t: delay time of permuation entropy, default t=1

%           tau: delay time in conditional mutual information

% Output: 
%           Ixy:  conditional mutual informaion (I(X,Dy|Y)) ;
%           Ixy:  conditional mutual informaion (I(Y,Dy|X)) ;

%           Dxy:  The direcionality of the coupling between the X and Y, X->Y; 
%                     if Out.Dxy > 0, means X->Y, otherwise X<-Y; 
          

%% referrence: Estimating coupling direction between neuronal populations
%% with permutation conditional mutual information, NeuroImage, 2010, 52:497-507 

%  revise time: Jan 5 2010, Ouyang, Gaoxiang and Li, Xiaoli 
% tic
Lop=1;
for i=1:ord
    Lop=Lop*i; %½×³Ë
end
OPxy=zeros(Lop,Lop);
OPdyy=zeros(Lop,Lop);
% OPdyx=zeros(Lop,Lop);
OPdxx=zeros(Lop,Lop);
OPdyxy=zeros(Lop,Lop,Lop);
OPdxyx=zeros(Lop,Lop,Lop);

% difference of X and Y;
% DeltaX = X(1:(end-tau))-X((1+tau):end);
% DeltaY = Y(1:(end-tau))-Y((1+tau):end);

% DeltaX = (X((1+tau):end));
% DeltaY = (Y((1+tau):end));

DeltaX = X((1+tau):end);
DeltaY = Y((1+tau):end);

% OPxI = arrayfun(@OrderP,(X(1:(end-tau))),(ord),(t));
% OPyI = arrayfun(@OrderP,(Y(1:(end-tau))),(ord),(t));
% 
% OPdxI = arrayfun(@OrderP,(DeltaX),(ord),(t));
% OPdyI = arrayfun(@OrderP,(DeltaY),(ord),(t));

% 
% tic
OPxI = OrderP_gpu(X(1:(end-tau)),ord,t);
OPyI = OrderP_gpu(Y(1:(end-tau)),ord,t);

OPdyI= OrderP_gpu(DeltaY,ord,t);
OPdxI= OrderP_gpu(DeltaX,ord,t);
% toc
% OPxI = (OrderP(X(1:(end-tau)),ord,t));
% OPyI = (OrderP(Y(1:(end-tau)),ord,t));
% 
% OPdyI= (OrderP(DeltaY,ord,t));
% OPdxI= (OrderP(DeltaX,ord,t));

% t1=toc
LL=length(OPxI);
for i=1:LL
    Inx=OPxI(i);
    Iny=OPyI(i);
    Indy=OPdyI(i);
    Indx=OPdxI(i);
    
    OPxy(Iny,Inx)=OPxy(Iny,Inx)+1;
    OPdyy(Iny,Indy)=OPdyy(Iny,Indy)+1;
%     OPdyx(Inx,Indy)=OPdyx(Inx,Indy)+1;
    OPdxx(Inx,Indx)=OPdxx(Inx,Indx)+1;
    OPdyxy(Iny,Inx,Indy)=OPdyxy(Iny,Inx,Indy)+1;
    OPdxyx(Inx,Iny,Indx)=OPdxyx(Inx,Iny,Indx)+1;
end
% toc
ProbY=(sum((OPxy),2));   
ProbX=(sum((OPxy),1));   

% ProbX=sum(OPxy,1);
% PDF X and Y 
ProbY=(ProbY/sum(ProbY));
ProbX=(ProbX/sum(ProbX));


p=ProbX(ProbX~=0);
ENx=-sum(p .* log(p));
p=ProbY(ProbY~=0);
ENy=-sum(p .* log(p));

ConENxy = 0;
ConENdyy= 0;
ENdyxy=0;

ConENyx=0;
ConENdxx=0;
ENdxyx=0;

for i=1:Lop
    PP=OPxy(i,:);
    PP=(PP(PP~=0));
    if ~isempty(PP)
        p = PP/sum(PP);
        ConENxy = (ConENxy-ProbY(i)*sum(p .* log(p)));
    end
    
    PP=(OPxy(:,i));
    PP=PP(PP~=0);
    if ~isempty(PP)
        p = (PP/sum(PP));
        ConENyx = (ConENyx-ProbX(i)*sum(p .* log(p)));
    end

    PP=(OPdyy(i,:));
    PP=PP(PP~=0);
    if ~isempty(PP)
        p = PP/sum(PP);
        ConENdyy = (ConENdyy-ProbY(i)*sum(p .* log(p)));
    end
    
    PP=(OPdxx(i,:));
    PP=PP(PP~=0);
    if ~isempty(PP)
        p = PP/sum(PP);
        ConENdxx = (ConENdxx-ProbX(i)*sum(p .* log(p)));
    end
    
    for j=1:Lop
        PP=(OPdyxy(i,j,:));
        PP=PP(PP~=0);
        if ~isempty(PP)
            p = PP/LL;
            ENdyxy = (ENdyxy-sum(p .* log(p)));
        end
    end
    
    for j=1:Lop
        PP=(OPdxyx(i,j,:));
        PP=PP(PP~=0);
        if ~isempty(PP)
            p = PP/LL;
            ENdxyx = (ENdxyx-sum(p .* log(p)));
        end
    end
    
end
% toc
ConENdyxy=ENdyxy-ENy;
ConENdxyx=ENdxyx-ENx;

Ixy=ConENxy+ConENdyy-ConENdyxy;
Iyx=ConENyx+ConENdxx-ConENdxyx;

Dxy=0;
if Ixy~=0
    Dxy=(Ixy-Iyx)/(Ixy+Iyx);
end
% t2=toc

% Dxy=gather(Dxy);
% Ixy=gather(Ixy);
% Iyx=gather(Iyx);
% toc
end


