function res = dz_parsestocklist()
    fid = fopen('src/stockslist.txt');
    C = textscan(fid,'%s %s %s %s','delimiter','\t');
    fclose(fid);
    res.code = C{1};
    res.shsz = C{2};
    res.name = C{3};
    res.industry = C{4};
end