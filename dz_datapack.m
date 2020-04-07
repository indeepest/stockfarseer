function res = dz_datapack(stockdata)
    res.stock = stockdata.stock;
    res.name = stockdata.name;
    res.length = stockdata.length;
    res.date = stockdata.date;
    
    % 变量提取
    open = res.stock(1,:)';
    close = res.stock(2,:)';
    low = res.stock(3,:)';
    high = res.stock(4,:)';
    volume = res.stock(5,:)';
    exchange = res.stock(6,:)';

    % Increment
    increment = (close - open)./open;
    res.stock = [res.stock;increment'];
    res.name = [res.name;'increment'];
    
    % 日期处理
%     res.stock =[res.stock;weekday(datetime(stockdata.date,'inputformat','yyyy-MM-dd'))];
%     res.name = [res.name;'weekday'];

    % MACD  -ok
    macd  = indicators(close,'macd');
    DIFF = macd(:,1)';
    DEA = macd(:,2)';
    MACD = (macd(:,3)*2)';
    
    res.stock = [res.stock;DIFF;DEA;MACD];
    res.name = [res.name;'DIFF';'DEA';'MACD'];
    
    % RSI  
    RSI16 = indicators(close,'rsi',16)';
    RSI12 = indicators(close,'rsi',12)';
    RSI24 = indicators(close,'rsi',24)';
    
    res.stock = [res.stock;RSI16;RSI12;RSI24];
    res.name = [res.name;'RSI16';'RSI12';'RSI24'];
    
    % KDJ   
    kdj = indicators([high low close],'kdj');
    K = kdj(:,1)';
    D = kdj(:,2)';
    J = kdj(:,3)';
    
    res.stock = [res.stock;K;D;J];
    res.name = [res.name;'K';'D';'J'];
    
    % WR  -ok
    wr = indicators([high low close],'william',10);
    WR = -wr';
    
    res.stock = [res.stock;WR];
    res.name = [res.name;'WR'];
    % BOLL -ok
    boll = indicators(close,'boll');
    BOLL_mid = boll(:,1)';
    BOLL_upper = boll(:,2)';
    BOLL_lower = boll(:,3)';
    
    res.stock = [res.stock;BOLL_mid;BOLL_upper;BOLL_lower];
    res.name = [res.name;'BOLL_mid';'BOLL_upper';'BOLL_lower'];
    % OBV
    obv = indicators([close volume],'obv');
    OBV = obv';
    
    res.stock = [res.stock;OBV];
    res.name = [res.name;'OBV'];
    % SAR
    sar = indicators([high low],'sar');
    SAR = sar';
    
    res.stock = [res.stock;SAR];
    res.name = [res.name;'SAR'];
    % CCI  
    cci = indicators([high low close],'cci');
    CCI = cci';
    
    res.stock = [res.stock;CCI];
    res.name = [res.name;'CCI'];
    % ROC
    roc = indicators(close,'roc');
    ROC = roc';
    
    res.stock = [res.stock;ROC];
    res.name = [res.name;'ROC'];
    % SMA
    sma = indicators(close,'sma');
    SMA = sma';
    
    res.stock = [res.stock;SMA];
    res.name = [res.name;'SMA'];
    % EMA
    ema = indicators(close,'ema');
    EMA = ema';
    
    res.stock = [res.stock;EMA];
    res.name = [res.name;'EMA'];
    
    % 去除NAN项
    nanidx = find(isnan(sum(res.stock)));
    if ~isempty(nanidx)
        res.stock = res.stock(:,nanidx(end)+1:end);
        res.date = res.date(nanidx(end)+1:end);
        res.length = size(res.stock,2);
    end
end

