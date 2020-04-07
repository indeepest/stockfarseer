function [res,para] = dz_zscore(data,varargin)
    if ~isempty(varargin)
        para = varargin{1};
    else
        para.mu = mean(data,2);
        para.sig = std(data,0,2);
    end
    res = (data - para.mu) ./ para.sig;
end