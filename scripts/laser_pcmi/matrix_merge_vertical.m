 %%矩阵整合，将输入的矩阵合并并输出,竖版
function combined=matrix_merge_vertical(matA,matB)
% if(isempty(matA))
%     combined=matB;
% else
%     if(size(matA)==size(matB))
        combined=[matA;matB];
%     else
%         combined=nan;
%     end
% end 