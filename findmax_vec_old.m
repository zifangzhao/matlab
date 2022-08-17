function idx = findmax_vec(vec1,vec2)

%%%%%%% find the maximum of both vec1 and vec2, in the case that there are multiple maximums, if the maximum in vec1,
%%%%%%% then the corresponding index element of vec2 is the minimum.

if length(vec1)~=length(vec2)
    error(' the two vecters must be same length!')
end

idx_max_tmp1 = find(vec1==max(vec1));
idx_max_tmp2 = find(vec2==max(vec2));

idx_tmp1 = vec2(idx_max_tmp1)==min(vec2(idx_max_tmp1));
idx_max1 = idx_max_tmp1(idx_tmp1);

idx_tmp2 = find(vec1(idx_max_tmp2)==min(vec1(idx_max_tmp2)));
idx_max2 = idx_max_tmp2(idx_tmp2(1));

tmp = [vec1(idx_max1) idx_max1; vec2(idx_max2) idx_max2];
tmp_a = sortrows(tmp);
idx = tmp_a(2,2);
