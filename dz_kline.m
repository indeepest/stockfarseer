function dz_kline(stockdata,varargin)
    data = stockdata.stock;
    open = data(1,:);
    close = data(2,:);
    low = data(3,:);
    high = data(4,:);
    volume = data(5,:);
    exchange = data(6,:);
    if ~isempty(varargin)
        ax = varargin{1};
    else
        ax = axes(figure());
    end
    for i = 1 : stockdata.length
        if open(i) == close(i)
            color = [0 0 0];
        elseif open(i) <= close(i)
            color = [1 0 0];
        else
            color = [0 0 1];
        end
        line(ax,[i i],[low(i) high(i)],'linewidth',1,'color',color);
        rectangle(ax,'position',[i-0.25,min(open(i),close(i)),0.5,abs(close(i)-open(i))],'facecolor',color,'edgecolor',color,'linewidth',1);
    end
    set(ax,'xlim',[0 stockdata.length+1]);
end