% DEMSPMGPGGJURA Demonstrate sparse convolution models on JURA data using
% the PITC approximation.

% MULTIGP
clear;
rand('twister', 1e6);
randn('state', 1e6);

dataSetName = 'juraData';
experimentNo = 2;
file = 'Cd';


[XTemp, yTemp, XTestTemp, yTestTemp] = mapLoadData([dataSetName file]);
scaleVal = zeros(1,size(yTemp, 2));
biasVal = zeros(1,size(yTemp, 2));
for k =1:size(yTemp, 2),
    biasVal(k) = mean(yTemp{k});
    scaleVal(k) = sqrt(var(yTemp{k}));
end

options = multigpOptions('pitc');
options.kernType = 'gg';
options.optimiser = 'scg';
options.nlf = 1;
options.initialInducingPositionMethod = 'kmeans';
options.numActive = 100;
options.fixInducing = 0;
options.beta = ones(1, size(yTemp, 2));
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

% Creates the model
model = multigpCreate(q, d, X, y, options);
% Change the inverse width of the outputs

params = modelExtractParam(model);
for i =1:model.nout,
    for j =1:model.q
        index = paramNameRegularExpressionLookup(model,['multi .* ' num2str(i) ...
            ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);
        avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + i}(:,j)))));
        params(index) = log(2) -2*log(avgLengthScale);
    end
end
model = modelExpandParam(model, params);

% Change the inverse width of the latent functions

params = modelExtractParam(model);
for j =1:model.q
    index = paramNameRegularExpressionLookup(model,['multi .* 1'  ...
        ' inverse width latent \(' num2str(j) ',' num2str(j) '\)']);
    avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + 1}(:,j)))));
    params(index) = log(2) - 2*log(0.1*avgLengthScale);
end
model = modelExpandParam(model, params);


display = 1;
iters = 500;
model = multigpOptimise(model, display, iters);

% Prediction
[mu, var] = multigpPosteriorMeanVar(model, XTestTemp);
maerror = mean(abs((yTestTemp{1} - mu{model.nlf + 1})));

mean(abs(mu{2}-yTestTemp{1}))
mean(abs(mu{3}-yTestTemp{2}))
mean(abs(mu{4}-yTestTemp{3}))

rmse = sqrt(mean((mu{2} - yTestTemp{1}).^2 ))


save('demSpmgGgJura1.mat', 'model');


