% https://www.mathworks.com/help/nnet/examples/transfer-learning-and-fine-tuning-of-convolutional-neural-networks.html?requestedDomain=true#d119e2174
function [ ret, ctime, rtime, acc ] = auxiliary_MobileTF(params, noise)
    load convnet;
    global home_dir 
    
    numepochs = params.numepochs;
    batchsize = params.batchsize;
    learningrate = params.learningrate;
    momentum = params.momentum;
    weightdecay = params.weightdecay;
% % Z1 = Z(find(Z~=A))
    
    disp('Evaluating Auxiliary Function');

    trainDatasetPath = fullfile([home_dir '/Data/mnist/imgs']);
    testDatasetPath = fullfile([home_dir '/Data/mnist/val_imgs']); 
    
    trainData = imageDatastore(trainDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    testData = imageDatastore(testDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    
%     [trainData,testData] = splitEachLabel(data,0.9,'randomize');
    
    layersTransfer = convnet.Layers(1:end-3);
    numClasses = 10;
    layers = [layersTransfer
%         fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];

    % Replace parameters with xx values.
    optionsTransfer = trainingOptions('sgdm', ...
                            'MaxEpochs',numepochs, ...
                            'InitialLearnRate',learningrate, ...
                            'MiniBatchSize',batchsize, ...
                            'Momentum', momentum, ...
                            'L2Regularization', weightdecay);
                        
    t = cputime;
    tic
    netTransfer = trainNetwork(trainData,layers,optionsTransfer);
    e = cputime - t;
    re = toc;
%   (100, 0.001 , 512) 2.0740e+04, 1.9182e+04
%   (50 , 0.001 , 512) 1.0215e+04, 9.3614e+03
%   (25 , 0.001 , 512) 4.8956e+03, 4.9600e+03
%   (25 , 0.0001, 512) 5.0860e+03, 4.9686e+03
%   (100, 0.0001, 128) 1.9749e+04, 

    YPred = classify(netTransfer,testData);
    YTest = testData.Labels;

    accuracy = sum(YPred==YTest)/numel(YTest);
    
    % Heavily penalise if accuracy is below threshold.
    % Consider passing threshold as argument.
    if accuracy > mean(auxAcc)
        penalty = 1;
    else
        penalty = accuracy;
    end
    ret = e/penalty + noise;
    acc = accuracy;
    ctime=e;
    rtime=re;
end

