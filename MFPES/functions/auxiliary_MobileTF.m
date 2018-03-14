% https://www.mathworks.com/help/nnet/examples/transfer-learning-and-fine-tuning-of-convolutional-neural-networks.html?requestedDomain=true#d119e2174
function [ ret, acc, ctime ] = auxiliary_MobileTF(xx, noise)
    load convnet;
    % Fix the correct file path for image data
    load homeDir;
    init;
    if (is_fx)
        trainDatasetPath = fullfile('/Users/HFX/Desktop/Bayesian Optimization on Smart Devices/Data/mnist/imgs');
        testDatasetPath = fullfile('/Users/HFX/Desktop/Bayesian Optimization on Smart Devices/Data/mnist/val_imgs'); 
    else
        trainDatasetPath = fullfile('C:\Users\leona\Downloads\Bayesian-Optimisation-on-Smart-Devices\Data\mnist\imgs');
        testDatasetPath = fullfile('C:\Users\leona\Downloads\Bayesian-Optimisation-on-Smart-Devices\Data\mnist\val_imgs');
    end
    trainData = imageDatastore(trainDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    testData = imageDatastore(testDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    
%     [trainData,testData] = splitEachLabel(data,0.9,'randomize');
    
    layersTransfer = convnet.Layers(1:end-3);
    numClasses = 10;
    layers = [layersTransfer
        fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        softmaxLayer
        classificationLayer];

    % Replace parameters with xx values.
    optionsTransfer = trainingOptions('sgdm', ...
                            'MaxEpochs',20, ...
                            'InitialLearnRate',0.0001, ...
                            'MiniBatchSize',100, ...
                            'Momentum', 0.9, ...
                            'L2Regularization', 0.0001);
    % Momentum 0.9 [0, 1]
    % L2Regularization, 0.0001 (weight decay)
                        
    t = cputime;
    netTransfer = trainNetwork(trainData,layers,optionsTransfer);
    e = cputime - t;
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
    if accuracy < 0.75
        penalty = 1;
    else
        penalty = accuracy;
    end
    
    ret = e/penalty + noise;
    acc = accuracy;
    ctime=e;
end

