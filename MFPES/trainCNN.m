% https://www.mathworks.com/help/nnet/ref/trainnetwork.html

clear all, close all

% Fix the correct file path for image data
load homeDir;
datasetPath = fullfile(homeDir,'TFimgs');
data = imageDatastore(datasetPath,...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    
[trainData,testData] = splitEachLabel(data,0.9,'randomize');

% 1s8c5z-relu-mp2-1s16c5z-relu-mp3-150n-tanh-9n
layers = [imageInputLayer([28 28 1]);
          convolution2dLayer(5,8,'Padding',1);
          reluLayer;
          maxPooling2dLayer(2,'Stride',2);
          convolution2dLayer(5,16,'Padding',1);
          reluLayer;
          maxPooling2dLayer(3,'Stride',3);
          fullyConnectedLayer(150);
          reluLayer;
          fullyConnectedLayer(10)
          softmaxLayer
          classificationLayer];
% https://www.mathworks.com/help/nnet/ref/tansig.html
% https://www.mathworks.com/help/nnet/ref/nnet.cnn.layer.additionlayer.html
% cellLayers = num2cell(layers);
% cellLayers{9}.transferFcn = 'tansig';
% layers = cell2mat(cellLayers);
% layers(9).transferFcn = 'tansig';

% Standardise the parameters
options = trainingOptions('sgdm','MaxEpochs',20,'InitialLearnRate',0.0001);
convnet = trainNetwork(trainData,layers,options);

YPred = classify(convnet,testData);
YTest = testData.Labels;

accuracy = sum(YPred==YTest)/numel(YTest);



      
      