function p=t_test(x1,x2)
% x1,x2为要进行t检验的两组数据，长度可以不相同
[h,p] = ttest2(x1,x2);
end

