%% 构建数据集
clear;clc;
% 生成数据
data = sin(1:0.1:100);
plot(data);
% 划分数据
nts = floor(numel(data)*0.8);
xtrain = data(1:nts);
ytrain = data(2:nts+1);
xtest = data(nts+1:end-1);
ytest = data(nts+2:end);
% 标准化数据
[xtrain para] = dz_zscore(xtrain);
ytrain = dz_zscore(ytrain,para);
xtest = dz_zscore(xtest,para);
%% 建立模型
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
%% 训练模型
SRNET = trainNetwork(xtrain,ytrain,SRNET,opts);
%% 预测数据
% 预热模型
SRNET = predictAndUpdateState(SRNET,xtrain);
yend = ytrain(end);
[SRNET,ypred] = predictAndUpdateState(SRNET,yend);

numTimeStepsTest = numel(xtest);
for i = 2:numTimeStepsTest
    [SRNET,ypred(1,i)] = predictAndUpdateState(SRNET,ypred(i-1));
end
% 去标准化
ypred = dz_dezscore(ypred,para);
% 绘图
figure
plot(data(1:nts))
hold on
idx = nts:(nts + numTimeStepsTest);
plot(idx,[data(nts) ypred],'.-')
hold off
%% 对比结果
figure
subplot(2,1,1)
plot(ytest)
hold on
plot(ypred,'.-')
hold off

subplot(2,1,2)
stem(ypred - ytest)


