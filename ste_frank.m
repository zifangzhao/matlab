%%standard error
function s=ste_frank(x,dim)
if nargin==1
    x_size=size(x);
    if ~isempty(find(x_size==1, 1));
    [~, dim]=max(x_size);
    else
        dim=1;
    end
    
end
n=size(x,dim);
s=std(x,[],dim)/sqrt(n);
