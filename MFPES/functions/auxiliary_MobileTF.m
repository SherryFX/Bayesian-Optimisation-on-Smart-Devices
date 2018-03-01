function [ ret ] = auxiliary_MobileTF(xx, noise)
    load convnet
    
    % Fix the correct file path for image data
    datasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
        'nndatasets','DigitDataset');
    data = imageDatastore(datasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    
    [trainDigitData,testDigitData] = splitEachLabel(data,0.5,'randomize');
    
    layersTransfer = net.Layers(1:end-3);
    
    layers = [ ...
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

    % Replace parameters with xx values.
    optionsTransfer = trainingOptions('sgdm', ...
                            'MaxEpochs',5, ...
                            'InitialLearnRate',0.0001, ...
                            'MiniBatchSize',64);
    
    t = cputime;
    netTransfer = trainNetwork(trainDigitData,layers,optionsTransfer);
    e = cputime-t;
    
    YPred = classify(netTransfer,testDigitData);
    YTest = testDigitData.Labels;

    accuracy = sum(YPred==YTest)/numel(YTest);
    
    % Heavily penalise if accuracy is below threshold.
    % Consider passing threshold as argument.
    if accuracy < 0.75
        penalty = 10^5;
    else
        penalty = 0;
    end
    
    ret = e + noise + penalty;
end

