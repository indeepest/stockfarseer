function [p res] = pz_oneway_anova(varargin)
% ���������������е����ط������,�����ÿ�����ݳ��ȿ��Բ�ͬ��������Ϊ������
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

