%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OPi = OrderP_gpu(S,ord,t)
S=gpuArray(S);
ly = length(S);
permlist = gpuArray(perms(1:ord));

% disp(['size of temp' num2str(ly)]);
% c(1:length(permlist))=0;
    
OPi=zeros(1,ly-t*(ord-1));
% OPi_gpu=gpuArray(OPi);
% tic
 for j=1:ly-t*(ord-1)
     temp_selected=S(j:t:j+t*(ord-1));
%      disp(['size of temp' num2str(size(temp_selected))]);
%      temp=gpuArray(temp_selected);
%      [~,temp2]=sort(temp);
%      iv=gather(temp2);
     [~,iv]=(sort(temp_selected));
     iv=repmat(iv,factorial(ord),1);
     temp=sum(abs(permlist-iv),2);
     find(temp);
     for jj=1:length(permlist)
         if (isequal(permlist(jj,:),iv))
             OPi(j)=jj;
%              OPi_gpu(j)=jj;
         end
     end
 end
 OPi=gather(OPi);
% toc
end
