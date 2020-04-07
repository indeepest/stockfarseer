function [basestockdata,predstockdata]= dz_stockpred(stockcode,func)
    date = datetime('now','format','yyyyMMdd');
    fromdate = char(date - days(7));
    stockdata = dz_getwebstockdata(stockcode,fromdate,char(date));
    if isempty(stockdata)
        basestockdata = [];
        predstockdata = [];
        return;
    end
    func(3,1);
    
    % Algorithmn Part Begain
    yhigh = stockdata.stock(4,1:end);
    ylow = stockdata.stock(3,1:end);
    x = 1 : numel(yhigh);
    whigh = polyfit(x,yhigh,3);
    wlow = polyfit(x,ylow,3);
    yphigh = polyval(whigh,x(end)+2);
    yplow = polyval(wlow,x(end)+2);
    % Algorithmn Part End
    func(3,2);
    
    preddata.stock =  [yphigh;yplow];
    preddays = dz_nextworkday(datetime(stockdata.date{end},'inputformat','yyyy-MM-dd'),2,'yyyy-MM-dd')
    preddata.date = {char(preddays(end))};
    preddata.name = {'high';'low'};
    preddata.length = size(preddata.stock,2);
    basestockdata = stockdata;
    predstockdata = preddata;

    func(3,3);
end