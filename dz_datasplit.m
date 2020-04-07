function [res1,res2]= dz_datasplit(stockdata,backlength)
%     res1 = stockdata;
%     res2 = stockdata;
    res1.stock = stockdata.stock(:,1:end-backlength);
    res2.stock = stockdata.stock(:,end-backlength+1:end);
    res1.name = stockdata.name;
    res2.name = stockdata.name;
    res1.date = stockdata.date(1:end-backlength);
    res2.date = stockdata.date(end-backlength+1:end);
    res1.length = size(res1.stock,2);
    res2.length = size(res2.stock,2);
end

