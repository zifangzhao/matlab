function parsave(fname, varargin)
save(fname,varargin{1});
if length(varargin)>1
    cellfun(@(x)  save(fname, x,'-append'),varargin(2:end));
end
end