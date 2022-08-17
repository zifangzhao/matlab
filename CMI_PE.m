
function [Dxy,Ixy,Iyx] = CMI_PE(X,Y,ord,t,tau,wnd)

%  Input:   X, Y time series;
%           order: order of permuation entropy,  ord!*ord!*ord!<N, N is length of series X and Y:
%           t: delay time of permuation entropy, default t=1

%           tau: delay time in conditional mutual information
%           wnd: analysing window used in cmi calculation
% Output:
%           Ixy:  conditional mutual informaion (I(X,Dy|Y)) ;
%           Ixy:  conditional mutual informaion (I(Y,Dy|X)) ;

%           Dxy:  The direcionality of the coupling between the X and Y, X->Y;
%                     if Out.Dxy > 0, means X->Y, otherwise X<-Y;


%% referrence: Estimating coupling direction between neuronal populations
%% with permutation conditional mutual information, NeuroImage, 2010, 52:497-507
% 2012-5-25 revised by Zifang Zhao, fixed DP calculation without judgement
% of if Ixy~=0
% 2012-5 revised by Zifang Zhao,fixed time-length for OrderP cal,
% normalized Ixy and Iyx with max(H(x|y),H(y|x))
%  revise time: Jan 5 2010, Ouyang, Gaoxiang and Li, Xiaoli
% tic

Lop=factorial(ord);
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

DeltaX = X(1+tau:tau+wnd);     %%!! 变长度计算？？
DeltaY = Y(1+tau:tau+wnd);
% OPxI = arrayfun(@OrderP,(X(1:(end-tau))),(ord),(t));
% OPyI = arrayfun(@OrderP,(Y(1:(end-tau))),(ord),(t));
%
% OPdxI = arrayfun(@OrderP,(DeltaX),(ord),(t));
% OPdyI = arrayfun(@OrderP,(DeltaY),(ord),(t));

%
% tic
OPxI = OrderP(X(1:wnd),ord,t);
OPyI = OrderP(Y(1:wnd),ord,t);

OPdyI= OrderP(DeltaY,ord,t);
OPdxI= OrderP(DeltaX,ord,t);
% toc
% OPxI = (OrderP(X(1:(end-tau)),ord,t));
% OPyI = (OrderP(Y(1:(end-tau)),ord,t));
%
% OPdyI= (OrderP(DeltaY,ord,t));
% OPdxI= (OrderP(DeltaX,ord,t));

% t1=toc
LL=length(OPxI);
% for i=1:LL
%     Inx=OPxI(i);
%     Iny=OPyI(i);
%     Indy=OPdyI(i);
%     Indx=OPdxI(i);
%     
%     OPxy(Iny,Inx)=OPxy(Iny,Inx)+1;
%     OPdyy(Iny,Indy)=OPdyy(Iny,Indy)+1;
%     %     OPdyx(Inx,Indy)=OPdyx(Inx,Indy)+1;
%     OPdxx(Inx,Indx)=OPdxx(Inx,Indx)+1;
%     OPdyxy(Iny,Inx,Indy)=OPdyxy(Iny,Inx,Indy)+1;
%     OPdxyx(Inx,Iny,Indx)=OPdxyx(Inx,Iny,Indx)+1;
% end
% OPxy2=zeros(Lop,Lop);
% OPdyy2=zeros(Lop,Lop);
% OPdxx2=zeros(Lop,Lop);
% OPdyxy2=zeros(Lop,Lop,Lop);
% OPdxyx2=zeros(Lop,Lop,Lop);

xy=[OPyI;OPxI];xy_u=(unique(xy','rows'))';
dyy=[OPyI;OPdyI];dyy_u=(unique(dyy','rows'))';
dxx=[OPxI;OPdxI];dxx_u=(unique(dxx','rows'))';
dyxy=[OPyI;OPxI;OPdyI];dyxy_u=(unique(dyxy','rows'))';
dxyx=[OPxI;OPyI;OPdxI];dxyx_u=(unique(dxyx','rows'))';

for m=1:size(xy_u,2)
%     rep_temp=repmat(xy_u(:,m),[1 LL]);
    OPxy(xy_u(1,m),xy_u(2,m))=length(find(xy(1,:)==xy_u(1,m)&(xy(2,:)==xy_u(2,m))));
end

for m=1:size(dyy_u,2)
%     rep_temp=repmat(dyy_u(:,m),[1 LL]);
    OPdyy(dyy_u(1,m),dyy_u(2,m))=length(find(dyy(1,:)==dyy_u(1,m)&dyy(2,:)==dyy_u(2,m)));
end

for m=1:size(dxx_u,2)
%     rep_temp=repmat(dxx_u(:,m),[1 LL]);
    OPdxx(dxx_u(1,m),dxx_u(2,m))=length(find(dxx(1,:)==dxx_u(1,m)&dxx(2,:)==dxx_u(2,m)));
end

for m=1:size(dyxy_u,2)
%     rep_temp=repmat(dyxy_u(:,m),[1 LL]);
    OPdyxy(dyxy_u(1,m),dyxy_u(2,m),dyxy_u(3,m))=length(find(dyxy(1,:)==dyxy_u(1,m)&dyxy(2,:)==dyxy_u(2,m)&dyxy(3,:)==dyxy_u(3,m)));
end

for m=1:size(dxyx_u,2)
%     rep_temp=repmat(dxyx_u(:,m),[1 LL]);
    OPdxyx(dxyx_u(1,m),dxyx_u(2,m),dxyx_u(3,m))=length(find(dxyx(1,:)==dxyx_u(1,m)&dxyx(2,:)==dxyx_u(2,m)&dxyx(3,:)==dxyx_u(3,m)));
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

Ixy=(ConENxy+ConENdyy-ConENdyxy)./(max(ConENxy,ConENdyy));
Iyx=(ConENyx+ConENdxx-ConENdxyx)./(max(ConENyx,ConENdxx));

% Dxy=nan;
% if Ixy~=0
    Dxy=(Ixy-Iyx)./(Ixy+Iyx);
% end
% t2=toc


end


