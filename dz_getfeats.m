function res = dz_getfeats(stockdata,varargin)
    idxs = [];
    for i = 1 : numel(varargin)
        idxs = [idxs find(strcmp(stockdata.name,varargin{i}))];
    end
    res = stockdata.stock(idxs,:);
end