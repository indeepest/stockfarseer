function res = dz_nextworkday(date,numdays,format)
    res = {};
    while true
        date = date + days(1);
        if ~ismember(weekday(date),[1 7])
            res = [res datetime(date,'format',format)];
            if numel(res) >= numdays
                break;
            end
        end
    end
end

