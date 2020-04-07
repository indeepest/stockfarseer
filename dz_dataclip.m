function res = dz_dataclip(stockdata,range)
    res = stockdata;
    res.stock = stockdata.stock(:,range);
    res.name = stockdata.name;
    res.date = stockdata.date(range);
end