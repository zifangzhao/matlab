%%�������ϣ�������ľ���ϲ������
function combined=matrix_merge(matA,matB)
% if(isempty(matA))
%     combined=matB;
% else
%     if(size(matA)==size(matB))
if size(matA,1)~=size(matB,1)
    combined=[matA; matB];
else
    combined=[matA matB];
end
%     else
%         combined=nan;
%     end
% end