%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OPi = OrderP_gpu(S,ord,t)

ly = length(S);
permlist = gpuArray(perms(1:ord));
% disp(['size of temp' num2str(ly)]);
% c(1:length(permlist))=0;

OPi=zeros(1,ly-t*(ord-1));
% OPi_gpu=gpuArray(OPi);
% tic
% temp_selected=zeros(ly-t*(ord-1),ord);
% for j=1:ly-t*(ord-1)
%     temp_selected(j,:)=S(j:t:j+t*(ord-1));
% end

temp_S=S';
temp_all=zeros(ly,ord);
temp_all(:,1)=temp_S;
for ord_ind=1:t:ord-1
    temp_S=circshift(temp_S,[-1 0]);
    temp_all(:,ord_ind+1)=temp_S;
end

temp_selected=temp_all(1:end-t*(ord-1),:);
%      disp(['size of temp' num2str(size(temp_selected))]);
%      temp=gpuArray(temp_selected);
%      [~,temp2]=sort(temp);
%      iv=gather(temp2);
[~,iv]=sort(temp_selected,2);
%      iv=repmat(iv,[length(permlist) 1]);
%      OPi(j)=find(any(permlist-iv,2)==0);
for jj=1:length(permlist)
    repsize=[ly-t*(ord-1) 1];
    tmp=arrayfun(@cal_gpu,repmat(permlist(jj,:),repsize),gpuArray(iv));
    loc=any(tmp,2);
    OPi(loc)=jj;
end

%  OPi=gather(OPi_gpu);
% toc
end
function loc=cal_gpu(temp_perm,iv)
    loc= (iv-temp_perm)==0;
%     OPi(loc)=jj;
end
