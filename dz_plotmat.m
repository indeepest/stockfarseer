function dz_plotmat(mat,varargin)
    if ~isempty(varargin)
        mat = mat(varargin{2},:);
        x = repmat(varargin{1},[size(mat,1) 1]);
    else
        x = repmat(1:size(mat,2),[size(mat,1) 1]);
    end
    plot(x',mat',varargin{3});
end