function res = dz_getworkdays(dates)
   res = [];
   for i = 1 : numel(dates)
       if weekday(dates(i)) > 1 &  weekday(dates(i)) < 7
           res = [res dates(i)];
       end
   end
end