function [maerror, elapsed_time, bound] = demSpmgpJuraBatch(file, numActive, approx, nlf, ...
    numFolds, experimentNo, iters, kernType, initialPosition)

% DEMSPMGPJURABATCH Demonstrate sparse convolution models on JURA data.
%
%	Description:
%	[maerror, elapsed_time, bound] = demSpmgpJuraBatch(file, numActive, approx, nlf, ...
%    numFolds, experimentNo, iters, kernType, initialPosition)
%% 	demSpmgpJuraBatch.m SVN version 244
% 	last update 2009-02-18T20:34:15.000000Z

dataSetName = 'juraData';
display = 1;
maerror =  zeros(numFolds,length(numActive));
elapsed_time =  zeros(numFolds,length(numActive));
n1 = cell(numFolds,length(numActive), length(file));
n2 = cell(numFolds,length(numActive), length(file));
bound = zeros(numFolds, length(numActive));

options = multigpOptions(approx);
options.kernType = kernType;
options.optimiser = 'scg';
options.nlf = nlf;
options.initialInducingPositionMethod = initialPosition;
options.fixInducing = 0;

for dataset =1:length(file)

    [XTemp, yTemp, XTestTemp, yTestTemp] = mapLoadData([dataSetName file{dataset}]);
    scaleVal = zeros(1,size(yTemp, 2));
    biasVal = zeros(1,size(yTemp, 2));
    for k =1:size(yTemp, 2),
        biasVal(k) = mean(yTemp{k});
        scaleVal(k) = sqrt(var(yTemp{k}));
    end

    options.beta = 5 + 5*rand(1, size(yTemp, 2));
    options.bias = biasVal;
    options.scale = scaleVal;

    X = cell(size(yTemp, 2),1);
    y = cell(size(yTemp, 2),1);

    for i = 1:size(yTemp, 2)
        y{i} = yTemp{i};
        X{i} = XTemp{i};
    end

    q = 2;
    d = size(yTemp, 2);

    for seudoPoints =1: length(numActive)

        options.numActive = numActive(seudoPoints);

        for fold =1: numFolds
            %if (dataset == 1) && (seudoPoints == 1)
            %n1{fold} =  rand('twister');
            %n2{fold} =  randn('state');
            %else
            %    rand('twister', n1{fold});
            %    randn('state', n2{fold});
            %end
            % Creates the model
            model = multigpCreate(q, d, X, y, options);

            % Initialize parameters

            params = modelExtractParam(model);
            for i =1:model.nout,
                for j =1:model.q
                    index = paramNameRegularExpressionLookup(model,['multi .* ' num2str(i) ...
                        ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);
                    avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + i}(:,j)))));
                    params(index) = log(2) -2*log(avgLengthScale);
                    %        params(index) = -2*log(1);
                end
            end
            for j =1:model.q
                index = paramNameRegularExpressionLookup(model,['multi .* 1'  ...
                    ' inverse width latent \(' num2str(j) ',' num2str(j) '\)']);
                avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + 1}(:,j)))));
                params(index) = log(2) - 2*log(0.1*rand*avgLengthScale);
                %params(index) = -2*log(0.1);
            end
%             meanInit = mean(XTemp{2});
%             params = modelExtractParam(model);
%             for i =1: model.q,
%                 paramInd = paramNameRegularExpressionLookup(model,['X_u .*' num2str(i) ')']);
%                 initialLoc = meanInit(1) + 0.5*randn(1,model.k);
%                 params(paramInd) = initialLoc;
%             end
            model = modelExpandParam(model, params);

            % Optimization procedure
            elapsed_time(fold, seudoPoints) = cputime;
            model = multigpOptimise(model, display, iters);
            elapsed_time(fold, seudoPoints) = elapsed_time(fold, seudoPoints)-cputime;

            % Evaluation of the bound

            params = modelExtractParam(model);
            bound(fold, seudoPoints) = modelObjective(params, model);

            % Prediction
            mu = multigpPosteriorMeanVar(model, XTestTemp);
            maerror(fold, seudoPoints) = mean(abs((yTestTemp{1} - mu{model.nlf + 1})));
            save([dataSetName num2str(experimentNo) file{dataset} kernType approx], ...
                'maerror', 'elapsed_time', 'n1', 'n2', 'bound')
        end
    end
end



