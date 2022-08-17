%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OPi = OrderP_old(S,ord,t)

ly = length(S);
permlist = (perms(1:ord));
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
     
     for jj=1:length(permlist)
         if (abs(permlist(jj,:)-iv))==0
             OPi(j)=jj;
%              OPi_gpu(j)=jj;
         end
     end
 end
%  OPi=gather(OPi_gpu);
% toc
end
