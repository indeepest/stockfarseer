function res = se(data)
    res = std(data)./sqrt(size(data,1));
end