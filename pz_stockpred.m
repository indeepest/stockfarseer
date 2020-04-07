function res = pz_stockpred(stockcode,numbackday,numpredday,varargin)
    today = datetime('now','format','yyyyMMdd');
    fromday = today - days(365);
    stockdata = dz_getwebstockdata(stockcode,char(fromday),char(today));
    [stockdata1 stockdata2] = dz_datasplit(stockdata,numbackday);
    endday = datetime(stockdata1.date{end});
    preddaychars = cellstr(dz_nextworkday(endday,numpredday,'yyyy-MM-dd'));
%     xtrain = stockdata1.stock(:,1:end-1);
%     ytrain = stockdata1.stock(:,2:end);
    xtrain = stockdata.stock(:,1:end-1);
    ytrain = stockdata.stock(:,2:end);
   
    [xtrain para] = dz_zscore(xtrain);
    ytrain = dz_zscore(ytrain,para);
    
    if ~isempty(varargin)
        SPNET = varargin{1};
    else
        inputSize = size(xtrain,1);
        numResponses = size(ytrain,1);
        numHiddenUnits = 100;
        SPNET = [ ...
            sequenceInputLayer(inputSize)
            lstmLayer(numHiddenUnits)
            fullyConnectedLayer(numResponses)
            regressionLayer];

        opts = trainingOptions('adam', ...
            'MaxEpochs',1000, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',125, ...
            'LearnRateDropFactor',0.2, ...
            'Verbose',0, ...
            'Plots','training-progress');

        SPNET = trainNetwork(xtrain,ytrain,SPNET,opts);
    end
    
    SPNET = predictAndUpdateState(SPNET,stockdata1.stock(:,1:end-1));
    yend = stockdata1.stock(:,end);
    [SPNET,ypred] = predictAndUpdateState(SPNET,yend);

    for i = 2 : numpredday
        [SPNET,ypred(:,i)] = predictAndUpdateState(SPNET,ypred(:,i-1));
    end

    ypred = dz_dezscore(ypred,para);
    predstockdata.stock = ypred;
    predstockdata.date = preddaychars;
    predstockdata.name = stockdata.name;
    predstockdata.length = size(ypred,2);
    res = predstockdata;
    dz_plotstock(stockdata,predstockdata);
end