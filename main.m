%% �������ݼ�
clear;clc;
% ��������
data = sin(1:0.1:100);
plot(data);
% ��������
nts = floor(numel(data)*0.8);
xtrain = data(1:nts);
ytrain = data(2:nts+1);
xtest = data(nts+1:end-1);
ytest = data(nts+2:end);
% ��׼������
[xtrain para] = dz_zscore(xtrain);
ytrain = dz_zscore(ytrain,para);
xtest = dz_zscore(xtest,para);
%% ����ģ��
inputSize = 1;
numResponses = 1;
numHiddenUnits = 5;

SRNET = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

opts = trainingOptions('adam', ...
    'MaxEpochs',150, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');
%% ѵ��ģ��
SRNET = trainNetwork(xtrain,ytrain,SRNET,opts);
%% Ԥ������
% Ԥ��ģ��
SRNET = predictAndUpdateState(SRNET,xtrain);
yend = ytrain(end);
[SRNET,ypred] = predictAndUpdateState(SRNET,yend);

numTimeStepsTest = numel(xtest);
for i = 2:numTimeStepsTest
    [SRNET,ypred(1,i)] = predictAndUpdateState(SRNET,ypred(i-1));
end
% ȥ��׼��
ypred = dz_dezscore(ypred,para);
% ��ͼ
figure
plot(data(1:nts))
hold on
idx = nts:(nts + numTimeStepsTest);
plot(idx,[data(nts) ypred],'.-')
hold off
%% �ԱȽ��
figure
subplot(2,1,1)
plot(ytest)
hold on
plot(ypred,'.-')
hold off

subplot(2,1,2)
stem(ypred - ytest)


