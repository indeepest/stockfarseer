function res = dz_filterfeats(stockdata,varargin)
    idxs = [];
    for i = 1 : numel(varargin)
        idx = find(strcmp(stockdata.name,varargin{i}));
        idxs = [idxs idx];
    end
    res.name = stockdata.name(idxs);
    res.stock = stockdata.stock(idxs,:);
    res.date = stockdata.date;
    res.length = stockdata.length;
end