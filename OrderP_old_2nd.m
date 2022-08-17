%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OPi = OrderP(S,ord,t)

ly = length(S);
permlist = (perms(1:ord));
% disp(['size of temp' num2str(ly)]);
% c(1:length(permlist))=0;

OPi=zeros(1,ly-t*(ord-1));
% OPi_gpu=gpuArray(OPi);
% tic
temp_selected=zeros(ly-t*(ord-1),ord);
for j=1:ly-t*(ord-1)
    temp_selected(j,:)=S(j:t:j+t*(ord-1));
end
%      disp(['size of temp' num2str(size(temp_selected))]);
%      temp=gpuArray(temp_selected);
%      [~,temp2]=sort(temp);
%      iv=gather(temp2);
[~,iv]=sort(temp_selected,2);
%      iv=repmat(iv,[length(permlist) 1]);
%      OPi(j)=find(any(permlist-iv,2)==0);
for jj=1:length(permlist)
    temp_perm=repmat(permlist(jj,:),[ly-t*(ord-1) 1]);
    loc= any(iv-temp_perm,2)==0;
    OPi(loc)=jj;
end

%  OPi=gather(OPi_gpu);
% toc
end
