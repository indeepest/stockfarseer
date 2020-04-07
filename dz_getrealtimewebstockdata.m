function res = dz_getrealtimewebstockdata(stockcode)
    stockinfo = dz_stockinfo(stockcode);
    if iscell(stockinfo)
        res = {};
        for i = 1 : numel(stockinfo)
            url = ['http://hq.sinajs.cn/list=' lower(stockinfo{i}.shsz) stockinfo{i}.code];
            text = regexp(webread(url),'\"(.+)\"','tokens');
            fields = regexp(text{1},',','split');
            fields = fields{1};
            resi.stockcode = stockcode{i};
            resi.stockname = fields{1};
            resi.currentprice = fields{4};
            resi.highprice = fields{5};
            resi.lowprice = fields{6};
            resi.date = fields{31};
            resi.time = fields{32};
            res = [res resi];
        end
    else
        url = ['http://hq.sinajs.cn/list=' lower(stockinfo.shsz) stockinfo.code];
        text = regexp(webread(url),'\"(.+)\"','tokens');
        fields = regexp(text{1},',','split');
        fields = fields{1};
        res.stockcode = stockcode;
        res.stockname = fields{1};
        res.currentprice = fields{4};
        res.highprice = fields{5};
        res.lowprice = fields{6};
        res.date = fields{31};
        res.time = fields{32};
    end
end