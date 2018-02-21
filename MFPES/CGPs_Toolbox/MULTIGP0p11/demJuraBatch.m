function [maerror, elapsed_time] = demJuraBatch(file, nlf, ...
    numFolds, experimentNo, iters, kernType)

% DEMJURABATCH Demonstrate convolution models on JURA data.
%
%	Description:
%	[maerror, elapsed_time] = demJuraBatch(file, nlf, ...
%    numFolds, experimentNo, iters, kernType)
%% 	demJuraBatch.m SVN version 266
% 	last update 2009-03-04T09:27:59.000000Z

dataSetName = 'juraData';
display = 1;
maerror =  zeros(numFolds,1);
elapsed_time =  zeros(numFolds,1);
bound = zeros(numFolds, 1);
n1 = zeros(numFolds);
n2 = zeros(numFolds);

options = multigpOptions('ftc');
options.kernType = kernType;
options.optimiser = 'scg';
options.nlf = nlf;

for dataset =1:length(file)

    [XTemp, yTemp, XTestTemp, yTestTemp] = mapLoadData([dataSetName file{dataset}]);
    scaleVal = zeros(1,size(yTemp, 2));
    biasVal = zeros(1,size(yTemp, 2));

    for k =1:size(yTemp, 2),
        biasVal(k) = mean(yTemp{k});
        scaleVal(k) = sqrt(var(yTemp{k}));
    end

    options.beta = ones(1, size(yTemp, 2));
    options.bias =  [zeros(1, options.nlf) biasVal];
    options.scale = [zeros(1, options.nlf) scaleVal];


    X = cell(size(yTemp, 2)+options.nlf,1);
    y = cell(size(yTemp, 2)+options.nlf,1);

    for j=1:options.nlf
        y{j} = [];
        X{j} = zeros(1, 2);
    end
    for i = 1:size(yTemp, 2)
        y{i+options.nlf} = yTemp{i};
        X{i+options.nlf} = XTemp{i};
    end

    XTest = cell(size(yTemp, 2)+options.nlf,1);

    for j=1:options.nlf
        XTest{j} = ones(1, 2);
    end
    for i = 1:size(yTemp, 2)
        XTest{i+options.nlf} = XTestTemp{i};
    end

    q = 2;
    d = size(yTemp, 2) + options.nlf;


    for fold =1: numFolds
        % Creates the model
        model = multigpCreate(q, d, X, y, options);

        % Change initial parameters
%         params = modelExtractParam(model);
%         for i =1:model.nout,
%             index = paramNameRegularExpressionLookup(model,['multi .* white ' num2str(model.nlf+i) ' variance']);
%             params(index) = log( 1/sqrt(5 + 5*rand) );
%         end
%         model = modelExpandParam(model, params);

        % Change initial locations of the seudo points

        % Optimization procedure
        elapsed_time(fold) = cputime;
        model = multigpOptimise(model, display, iters);
        elapsed_time(fold) = elapsed_time(fold)-cputime;

        % Evaluation of the bound

        params = modelExtractParam(model);
        bound(fold) = modelObjective(params, model);

        
        % Prediction
        
        mu = multigpPosteriorMeanVar(model, XTest);
        maerror(fold) = mean(abs((yTestTemp{1} - mu{model.nlf + 1})));
        save([dataSetName num2str(experimentNo) file{dataset} kernType 'ftc'], ...
            'maerror', 'elapsed_time', 'bound', 'n1', 'n2')
    end

end



