function res = dz_getlocalstockdata(filename)
    text = dz_readtext(filename);
    text = regexp(text,'\[.*\]','match');
    stc = jsondecode(text{1});
    date = cell(1,numel(stc.hq));% date
    data = zeros(9,numel(stc.hq));% (1)open (2)close (3)increase (4)increase% (5)low (6)high (7)volume (8)volume_money
    for i = 1 : numel(stc.hq)
        idata = stc.hq{i};
        date{i} = idata{1};
        data(:,i) = [str2double(idata{2});str2double(idata{3});str2double(idata{4});str2double(idata{5}(1:end-1))*0.01;str2double(idata{6});str2double(idata{7});str2double(idata{8});str2double(idata{9});str2double(idata{10}(1:end-1))*0.01;];
    end
    res.date = fliplr(date);
    res.stock = fliplr(data);
    res.name = {'open_price';'close_price';'price_increasement';'price_increasement %';'lowest_pirce';'highest_price';'volume';'bill'};
end