function res = ddz_getwebstockdataAtyesterday(stockcode)
    today = datetime('yesterday','format','yyyyMMdd');
    stockdata = dz_getwebstockdata(stockcode,char(today),char(today));
    if isempty(stockdata)
        res = [];
        return;
    end
    res.stockcode = stockcode;
%     res.stockname = '';
    res.currentprice = stockdata.stock(2);
    res.highprice = stockdata.stock(4);
    res.lowprice = stockdata.stock(3);
    res.date = stockdata.date{1};
    res.time = stockdata.date{1};
end