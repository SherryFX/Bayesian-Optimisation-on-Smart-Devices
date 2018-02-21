function [yEst, z, W] = demPpcaFxData(dataSetName);

% DEMPPCAFXDATA Demonstrate PPCA model (for comparison purposes with LFM
%
%	Description:
%	model) on exchange rates data.
%	
%
%	[YEST, Z, W] = DEMPPCAFXDATA(DATASETNAME) Provides the results of
%	PPCA applied to the FX data set with missing data.
%	 Returns:
%	  YEST - estimated outputs.
%	  Z - transformed outputs in latent space.
%	  W - transformation matrix such that yEst = z * W'.
%	 Arguments:
%	  DATASETNAME - The data set to load.
%	
%
%	See also
%	DEMSIMDTCFXDATA, LOADFXDATA, FXDATARESULTS


%	Copyright (c) 2009 David Luengo
% 	demPpcaFxData.m SVN version 394
% 	last update 2009-06-07T17:58:51.000000Z


rand('seed', 1e6);
randn('seed', 1e6);

% Load data

data = loadFxData(dataSetName);

% Options for the demo

optionMeanVal = 'sampleMean';
% optionMeanVal = 'initVal';
offsetX = 1;
display = 1;
niter = 1000;

nout = size(data.y, 2);
ndata = size(data.y{1}, 1);

% Set the missing data for the demo

missingData = cell(1, nout);
missingData{4} = 50:100;
% missingData{5} = 200:250;
missingData{6} = 100:150;
% missingData{7} = 1:50;
missingData{9} = 150:200;

% Set the inputs and outputs in the correct format

X = zeros(ndata, nout);
y = zeros(ndata, nout);
meanVal = zeros(1, nout);
scaleVal = ones(1, nout);
count = offsetX + (0:ndata-1)';
for i = 1:nout
    if ~isempty(missingData{i})
        data.y{i}(missingData{i}) = 0.0;
    end
    ind1 = find(data.y{i} ~= 0.0);
    ind2 = find(data.y{i} == 0.0);
    data.y{i}(ind2) = NaN;
    scaleVal(i) = std(data.y{i}(ind1));
    if strcmp(optionMeanVal, 'sampleMean')
        meanVal(i) = mean(data.y{i}(ind1));
    elseif strcmp(optionMeanVal, 'initVal')
        meanVal(i) = data.y{i}(ind1(1));
    else
        error('Mean value option not defined');
    end
    y(:, i) = (data.y{i} - meanVal(i))/scaleVal(i);
    X(:, i) = count;
end

% Embedding of the missing data with PPCA

[z, sigma2, W] = ppcaEmbed(y, nout);
if rank(W)<nout
    [z, sigma2, W] = ppcaEmbed(y, rank(W));
end

% Creating and training an independent GP model for each output

options = gpOptions('ftc');

for i=1:size(z, 2)
    eval(['model' num2str(i) ' = gpCreate(1, 1, X(:, i), z(:, i), options);']);
    eval(['model' num2str(i) ' = gpOptimise(model' num2str(i) ', display, niter);']);
end

% Recover the estimate of the original data

yEst = z*W';
yEst = yEst .* repmat(scaleVal, size(y, 1), 1) + repmat(meanVal, size(y, 1), 1);

save demPpcaFxDataResults yEst z W;