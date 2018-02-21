function  logModel =  trainModelHighInGgwhite(X, y, numActive, nout, iters )

% TRAINMODELHIGHINGGWHITE Trains the DTC VAR approx for GGWHITE kernel
%
%	Description:
%
%	LOGMODEL = TRAINMODELHIGHINGGWHITE(X, Y, NUMACTIVE, NOUT, ITERS)
%	Trains a multigp model with DTC VAR approx with fixed parameters
%	 Returns:
%	  LOGMODEL - the bound given by the approx.
%	 Arguments:
%	  X - set of training inputs
%	  Y - set of training observations
%	  NUMACTIVE - number of pseudo points used for the approx.
%	  NOUT - number of outputs
%	  ITERS - number of iterations for the optimization
%	SEE ALSO : multigpCreate, muligpOptimise
%	


%	Copyright (c) 2009 Mauricio Alvarez
% 	trainModelHighInGgwhite.m SVN version 399
% 	last update 2009-06-10T20:54:00.000000Z

inverseWidth = [10 5 5 100 30 200 400 20 1 40];
sensitivity =  [1  2  2.2 1.5 1  3   4   2  1    10];
noisePerOutput = 1e2;


options = multigpOptions('dtc');
options.kernType = 'ggwhite';
options.optimiser = 'scg';
options.nlf = 1;
options.initialInducingPositionMethod = 'randomComplete';
options.numActive = numActive;
options.beta = 1e-4*ones(1, nout);
options.fixInducing = false;
options.tieOptions.selectMethod = 'nofree';
options.includeNoise = 1;

q = size(X{1},2);
d = size(y, 2);

% Creates the model
model = multigpCreate(q, d, X, y, options);

modelAux = model;
modelAux.paramGroups = speye(size(model.paramGroups,1));
count = length(model.fix);
% Fix inverse width parameters

for i =1:model.nout
    paramInd = paramNameRegularExpressionLookup(modelAux, ['. ggwhite ' num2str(i)...
                                ' inverse width output .*']);
    for k = 1:length(paramInd)
        count = count + 1;
        model.fix(count).index = paramInd(k);
        model.fix(count).value = expTransform(inverseWidth(i), 'xtoa');
    end
end
% Fix sensitivities
for i =1:model.nout
    paramInd = paramNameRegularExpressionLookup(modelAux, ['. ggwhite ' num2str(i)...
                                ' sensitivity']);
    for k = 1:length(paramInd)
        count = count + 1;
        model.fix(count).index = paramInd(k);
        model.fix(count).value = sensitivity(i);
    end                     
end
% Fix variance parameter of the noise
for i =1:model.nout
    paramInd = paramNameRegularExpressionLookup(modelAux, ['Beta ' num2str(i)]);
    count = count + 1;
    model.fix(count).index = paramInd(1);
    model.fix(count).value = expTransform(noisePerOutput, 'xtoa');
end

for i =1:model.nout
    paramInd = paramNameRegularExpressionLookup(modelAux, ['. white ' num2str(i+1)...
                                ' variance']);
    for k = 1:length(paramInd)
        count = count + 1;
        model.fix(count).index = paramInd(k);
        model.fix(count).value = expTransform(1e-5, 'xtoa');
    end
end

fixingLengthScale = 0;

for i=1:model.nlf
    if fixingLengthScale
        paramInd = paramNameRegularExpressionLookup(modelAux, ['multi ' num2str(i) ' gaussianwhite .* inverse width latent .*']);
        for k = 1:length(paramInd)
            count = count + 1;
            model.fix(count).index = paramInd(k);
            model.fix(count).value = expTransform(inverseWidth(i), 'xtoa');
        end
    else
        params =  modelExtractParam(model);
        paramInd = paramNameRegularExpressionLookup(model, '. gaussianwhite .* inverse width latent .*');
        params(paramInd) = log(mean(inverseWidth(1:nout))); % The value of the last simulation
        model = modelExpandParam(model, params);
    end
end

displayGradchek = 1;

% Trains the model 

model = multigpOptimise(model, displayGradchek, iters);

logModel = multigpLogLikelihood(model); 

