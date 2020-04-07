function [basestockdata,predstockdata]= dz_stockpred(stockcode,numdays,varargin)
    date = datetime('now','format','yyyyMMdd');
    nowdate = char(date);
    fromdate = char(date - days(365));
    stockdata = dz_getwebstockdata(stockcode,fromdate,nowdate);
    if isempty(stockdata)
        basestockdata = [];
        predstockdata = [];
        return;
    end
%     stockdata = dz_datapack(stockdata);
%     stockdata = dz_filterfeats(stockdata,'low','high','close','open','volume','exchange','RSI16','MACD','K','D','J','WR');
    stockdata = dz_filterfeats(stockdata,'low','high');
    callbackf = [];
    needplot = true;
    backday = 0;
    xtrain = stockdata.stock(:,1:end-1);
    ytrain = stockdata.stock(:,2:end);
    if ~isempty(varargin)
        callbackf = varargin{1};
        if numel(varargin) >= 2
            needplot = varargin{2};
        end
        if numel(varargin) == 3
            backday = varargin{3};
            [stockdata1 stockdata2] = dz_datasplit(stockdata,backday);
            xtrain = stockdata1.stock(:,1:end-1);
            ytrain = stockdata1.stock(:,2:end);
        end
    end
    date_ = datetime(stockdata.date{end},'inputformat','yyyy-MM-dd');
    preddatelist = cellstr(dz_nextworkday(date_ - days(backday),numdays,'yyyy-MM-dd'));
    numdays = numel(preddatelist);
    
    
    
    
    
    
    
    
    
    
    % ���ݱ�׼��
    [xtrain para] = dz_zscore(xtrain);
    ytrain = dz_zscore(ytrain,para);
    % ����ģ��
    SPNET = [sequenceInputLayer(size(xtrain,1))
            lstmLayer(100)
            fullyConnectedLayer(size(ytrain,1))
            regressionLayer];
    if ~isempty(callbackf)
        opts = trainingOptions('adam', ...
                            'MaxEpochs',500, ...
                            'GradientThreshold',1, ...
                            'InitialLearnRate',0.005, ...
                            'LearnRateSchedule','piecewise', ...
                            'LearnRateDropPeriod',125, ...
                            'LearnRateDropFactor',0.2, ...
                            'Verbose',0, ...
                            'Plots','none',...
                            'OutputFcn',callbackf...
                            );
    else
        opts = trainingOptions('adam', ...
                            'MaxEpochs',500, ...
                            'GradientThreshold',1, ...
                            'InitialLearnRate',0.005, ...
                            'LearnRateSchedule','piecewise', ...
                            'LearnRateDropPeriod',125, ...
                            'LearnRateDropFactor',0.2, ...
                            'Verbose',0, ...
                            'Plots','none'...
                            );
    end
    % ѵ��ģ��
    SPNET = trainNetwork(xtrain,ytrain,SPNET,opts);
    % Ԥ��ģ��
    % ��xtrain�е�����ʱ�䲽��˳��ȫ����ģ���й�һ�飬ÿ��һ��ʱ�䲽��ˢ��ϸ��״̬�����������ģ�ͣ���ϸ��״̬���������һ��ˢ�µ�״̬
    SPNET = predictAndUpdateState(SPNET,xtrain);
    % �ν�
    yend = ytrain(:,end);
    [SPNET,ypred] = predictAndUpdateState(SPNET,yend);
    % ѭ��Ԥ��
    control = false;
    for i = 2 : numdays
        if control
            [SPNET,ypredtemp] = predictAndUpdateState(SPNET,ypred(:,i-1));
            if ypred(3,i-1)-ypredtemp(1) > ypred(3,i-1)*0.1
                ypredtemp(1) = ypred(3,i-1)*0.9;
            end
            if ypred(3,i-1)-ypredtemp(3) > ypred(3,i-1)*0.1
                ypredtemp(3) = ypred(3,i-1)*0.9;
            end
            if ypredtemp(2)-ypred(3,i-1) > ypred(3,i-1)*0.1
                ypredtemp(2) = ypred(3,i-1)*1.1;
            end
            if ypredtemp(4)-ypredtemp(3) > ypredtemp(3)*0.1
                ypredtemp(4) = ypredtemp(3)*1.1;
            end
            ypred(:,i) = ypredtemp;
        else
            [SPNET,ypred(:,i)] = predictAndUpdateState(SPNET,ypred(:,i-1));
        end
    end
    % ȥ��׼��
    ypred = dz_dezscore(ypred,para);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    % ��װ����
    preddata.stock = ypred;
    preddata.date = preddatelist;
    preddata.name = stockdata.name;
    preddata.length = size(ypred,2);
    % ��ͼ
    if needplot
        dz_plotstock(stockdata,preddata);
    end
    % ����
    basestockdata = stockdata;
    predstockdata = preddata;
end