function dz_writetext(filename,text)
    fid = fopen(filename,'wt');
    fprintf(fid,'%s',text);
    fclose(fid);
end