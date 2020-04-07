function [cred res] = ddz_stockpred(stockcode,callbackf,rollbackone)
    numpredday = 10;
    if rollbackone
        today = datetime('yesterday','format','yyyyMMdd') - days(1);
    else
        today = datetime('yesterday','format','yyyyMMdd');
    end
    fromday = today - days(365);
    stockdata = dz_getwebstockdata(stockcode,char(fromday),char(today));
    endday = datetime(stockdata.date{end});
    preddaychars = cellstr(dz_nextworkday(endday,numpredday,'yyyy-MM-dd'));
    xtrain = stockdata.stock(:,1:end-1);
    ytrain = stockdata.stock(:,2:end);
   
    [xtrain para] = dz_zscore(xtrain);
    ytrain = dz_zscore(ytrain,para);
    
    inputSize = size(xtrain,1);
    numResponses = size(ytrain,1);
    numHiddenUnits = 100;
    SPNET = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits)
        fullyConnectedLayer(numResponses)
        regressionLayer];

    opts = trainingOptions('adam', ...
        'MaxEpochs',500, ...
        'GradientThreshold',1, ...
        'InitialLearnRate',0.005, ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropPeriod',125, ...
        'LearnRateDropFactor',0.2, ...
        'Verbose',0, ...
        'OutputFcn',callbackf...
                            );
    
    SPNET = trainNetwork(xtrain,ytrain,SPNET,opts);
    SPNET = predictAndUpdateState(SPNET,xtrain);
    [SPNET,ypred] = predictAndUpdateState(SPNET,ytrain(:,end));

    for i = 2 : numpredday
        [SPNET,ypred(:,i)] = predictAndUpdateState(SPNET,ypred(:,i-1));
    end

    ypred = dz_dezscore(ypred,para);
    predstockdata.stock = ypred;
    predstockdata.date = preddaychars;
    predstockdata.name = stockdata.name;
    predstockdata.length = size(ypred,2);
    res = predstockdata;
    
    % ÷√–≈∂»
    cred = 1;
    
%     dz_plotstock(stockdata,predstockdata);
end