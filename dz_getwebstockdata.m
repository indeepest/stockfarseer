function res = dz_getwebstockdata(stockcode,fromdate,todate)
    url = ['http://q.stock.sohu.com/hisHq?code=cn_' stockcode '&start=' fromdate '&end=' todate '&stat=1&order=D&period=d&callback=historySearchHandler&rt=jsonp'];
    text = webread(url);
    text = regexp(text,'\[.*\]','match');
    if isempty(text)
        res = [];
        return;
    end
    
    stc = jsondecode(text{1});
    date = cell(1,numel(stc.hq));% date
    data = zeros(6,numel(stc.hq));% (1)open (2)close (3)low (4)high (5)volume (6)exchange
    for i = 1 : numel(stc.hq)
        idata = stc.hq{i};
        date{i} = idata{1};
        data(:,i) = [str2double(idata{2});str2double(idata{3});str2double(idata{6});str2double(idata{7});str2double(idata{8});str2double(idata{10}(1:end-1))*0.01];
    end
    res.date = fliplr(date);
    res.stock = fliplr(data);
    res.name = {'open';'close';'low';'high';'volume';'exchange'};
    res.length = size(res.stock,2);
end