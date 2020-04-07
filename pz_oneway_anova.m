function [p res] = pz_oneway_anova(varargin)
% 对输入的数据组进行单因素方差分析,输入的每个数据长度可以不同，但必须为列向量
    vector = [];
    namesArray = [];
    for j = 1 : length(varargin)
        column = varargin{j};
        vector = [vector column'];
        for i = 1 : length(column)
            namesArray = [namesArray j];
        end
    end
    namesCell = {};
    for i = 1 : length(namesArray)
        namesCell{i} = num2str(namesArray(i));
    end
    [p tab stats]= anova1(vector,namesCell,'off');
    [c,m,h,nms] = multcompare(stats,'display','off');
    res.p=p;
    res.tab=tab;
    res.stats=stats;
    res.c=c;
    res.m=m;
    res.nms=nms;
end

