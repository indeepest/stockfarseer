clear;clc;
%% ����Ԥ����

stockdata = dz_getwebstockdata('600895','20181218','20191218');

data = stockdata.stock;

% ��������
numstep_train = floor(size(data,2) * 0.8);

xtrain = data(:,1:numstep_train);

ytrain = data(:,2:numstep_train+1);

xtest = data(:,numstep_train+1:end-1);

ytest = data(:,numstep_train+2:end);

% ���ݱ�׼��
[xtrain para] = dz_zscore(xtrain);

ytrain = dz_zscore(ytrain,para);

xtest = dz_zscore(xtest,para);
%% ����ģ��
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
    'Plots','training-progress');
%% ѵ��ģ��
SPNET = trainNetwork(xtrain,ytrain,SPNET,opts);
%% Ԥ������
% Ԥ��ģ��
SPNET = predictAndUpdateState(SPNET,xtrain);
yend = ytrain(:,end);
[SPNET,ypred] = predictAndUpdateState(SPNET,yend);

numstep_test = size(xtest,2);
for i = 2 : numstep_test
    [SPNET,ypred(:,i)] = predictAndUpdateState(SPNET,ypred(:,i-1));
end
% ȥ��׼��
ypred = dz_dezscore(ypred,para);
% ��ͼ
figure(1)
dz_plotmat(data,1:size(data,2),[3 4],'b');
hold on
dz_plotmat([data(:,numstep_train) ypred],numstep_train:numstep_train+numstep_test,[3 4],'r');
hold off




