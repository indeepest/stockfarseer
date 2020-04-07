clear;clc;

sl = load('src/stocklist.mat');
stockcode = sl.stocklist.code();
randindexs = randperm(numel(stockcode),20);
stockcodelist = stockcode(randindexs);

stockdata ={};
for i = 1 : numel(stockcodelist)
    stockdata = [stockdata;dz_getwebstockdata(stockcodelist{i},'20181226','20191225')];
end

isFirstTrain = false;

if isFirstTrain
    inputSize = 6;
    numResponses = 6;
    numHiddenUnits = 100;

    SPNET = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits)
        fullyConnectedLayer(numResponses)
        regressionLayer];
else
    spnet = load('model/spnet.mat');
    SPNET = spnet.SPNET;
end

opts = trainingOptions('adam', ...
    'MaxEpochs',500, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

for i = 1 : numel(stockdata)
    data = stockdata{i}.stock;
    xtrain = data(:,1:end-1);
    ytrain = data(:,2:end);
    [xtrain para] = dz_zscore(xtrain);
    ytrain = dz_zscore(ytrain,para);
    SPNET = trainNetwork(xtrain,ytrain,SPNET,opts);
    fprintf(['- ' num2str(i) ' -\n']);
end

