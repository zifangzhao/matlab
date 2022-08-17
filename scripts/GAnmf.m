%GA NMF oringinal
function [W,H]=GAnmf(data,R,popu_size,goal_diff,max_iteration)
%initial 
W_all=mapminmax(rand(size(data,1),R,popu_size),0,1);
H_all=rand(R,size(data,2),popu_size);
W_all_new=W_all;
H_all_new=H_all;
m_rate=0.05;
Ori_num=round(0.7*popu_size);
Mut_num=round(0.2*popu_size);
Per_num=popu_size-Ori_num-Mut_num;
%evaluation
var=arrayfun(@(x) data-W_all(:,:,x)*H_all(:,:,x),1:popu_size);
% original:mutation:permutation=7:2:1
[~ ix]=sort(var);
W_all_new(:,:,1:Ori_num)=W_all(:,:,ix(1:Ori_num));
H_all_new(:,:,1:Ori_num)=H_all(:,:,ix(1:Ori_num));
%mutation rate=5%

temp=randperm(Ori_num); %pick up mutation source from best fits
loc=ix(temp(1:Mut_num));

mumap_W=ones(size(data,1),R,Mut_num);
mumap_H=ones(R,size(data,2),Mut_num);
W_all_new(:,:,Ori_num+1:Ori_num+Mut_num)=W_all(:,:,loc).*mumap_W;
H_all_new(:,:,Ori_num+1:Ori_num+Mut_num)=H_all(:,:,loc).*mumap_H;
%hybrid

%normalize W

%update
