function res = dz_readtext(filename)
    fid = fopen(filename);
    res = fscanf(fid,'%s');
    fclose(fid);
end