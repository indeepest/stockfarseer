function res = dz_stockinfo(stockname)
    para = load('src/stocklist.mat');
    stocklist = para.stocklist;
    if iscell(stockname)
        res = {};
        for i = 1 : numel(stockname)
            if ~isempty(regexp(stockname{i},'\d{6}','once'))
                index = find(strcmp(stockname{i},stocklist.code));
            else
                index = find(strcmp(stockname{i},stocklist.name));
            end
            if ~isempty(index)
                index = index(1);
                resi.name = stocklist.name{index};
                resi.code = stocklist.code{index};
                resi.industry = stocklist.industry{index};
                resi.shsz = stocklist.shsz{index};
            else
                resi = struct();
                resi.name = '--';
                resi.code = stockname{i};
                if startsWith(stockname{i},'6')
                    resi.shsz = 'SH';
                elseif startsWith(stockname{i},'0')
                	resi.shsz = 'SZ';
                end
            end
            res = [res resi];
        end
    else
        if ~isempty(regexp(stockname,'\d{6}','once'))
            index = find(strcmp(stockname,stocklist.code));
        else
            index = find(strcmp(stockname,stocklist.name));
        end
        if ~isempty(index)
            index = index(1);
            res.name = stocklist.name{index};
            res.code = stocklist.code{index};
            res.industry = stocklist.industry{index};
            res.shsz = stocklist.shsz{index};
        else
            res.code = stockname;
            res.name = stockname;
            if startsWith(stockname,'6')
                res.shsz = 'SH';
            elseif startsWith(stockname,'0')
                res.shsz = 'SZ';
            end
        end
    end
end