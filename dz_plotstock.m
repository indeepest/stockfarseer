function dz_plotstock(basedata,preddata,varargin)
    ybase = dz_getfeats(basedata,'low','high');
    xbase = 1 : basedata.length;
    lbase = basedata.date;
    idx = find(strcmp(lbase,preddata.date{1}));
    if isempty(idx)
        ypred = [ybase(:,end) dz_getfeats(preddata,'low','high')];
        xpred = basedata.length : basedata.length + preddata.length;
        datelabel = [lbase preddata.date];
    else
        idx = idx(1);
        ypred = [ybase(:,idx-1) dz_getfeats(preddata,'low','high')];
        xpred = idx-1:idx-1+preddata.length;
        datelabel = [lbase(1:idx-1) preddata.date];
        if numel(lbase) > numel(datelabel)
            datelabel = lbase;
        end
    end
    if ~isempty(varargin)
        ax = varargin{1};
    else
        ax = axes(figure());
    end
    hold(ax,'on');
    plot(ax,repmat(xbase,2,1)',ybase','linewidth',2,'color',[0 0.45 0.74],'marker','o','markersize',5,'markerfacecolor',[0 0.45 0.74]);
    plot(ax,repmat(xpred,2,1)',ypred','linewidth',2,'color',[0.85 0.33 0.10],'marker','o','markersize',5,'markerfacecolor',[1 1 1]);
    set(ax,'xtick',1 : numel(datelabel));
    set(ax,'xticklabel',datelabel);
    set(ax,'xticklabelrotation',60);
end