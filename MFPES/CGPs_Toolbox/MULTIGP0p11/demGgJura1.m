clear;
% DEMGGJURA Demonstrate multigp convolution model on JURA data using
%
%	Description:
%	the FULL covariance matrix.
% 	demGgJura.m SVN version 312
% 	last update 2009-04-08T10:39:37.000000Z

rand('twister', 1e6);
randn('state', 1e6);

dataSetName = 'juraData';
experimentNo = 1;
file = 'Cd';

%arik:load data
[XTemp, yTemp, XTestTemp, yTestTemp] = mapLoadData([dataSetName file]);
%arik:pre-processing
scaleVal = zeros(1,size(yTemp, 2));
biasVal = zeros(1,size(yTemp, 2));
for k =1:size(yTemp, 2),
    biasVal(k) = mean(yTemp{k});
    scaleVal(k) = sqrt(var(yTemp{k}));
end
%full GP: fitc/ftc/pitc...
options = multigpOptions('ftc');
%type of kernel: gausian kernel
options.kernType = 'gg';
%optimization
options.optimiser = 'scg';
% no. of latent proess: see eq. (8) Q
options.nlf = 1;
% noise variance
options.beta = ones(1, size(yTemp, 2));
% mean
options.bias =  [zeros(1, options.nlf) biasVal];
% output variance
options.scale = [zeros(1, options.nlf) scaleVal];

% q: input dim, d: output dim + no. of latent process (for FGP only)
q = 2;
d = size(yTemp, 2) + options.nlf;

X = cell(size(yTemp, 2)+options.nlf,1);
y = cell(size(yTemp, 2)+options.nlf,1);

for j=1:options.nlf
    y{j} = [];
    X{j} = zeros(1, q);
end
for i = 1:size(yTemp, 2)
    y{i+options.nlf} = yTemp{i};
    X{i+options.nlf} = XTemp{i};
end

XTest = cell(size(yTemp, 2)+options.nlf,1);

for j=1:options.nlf
    XTest{j} = ones(1, q);
end
for i = 1:size(yTemp, 2)
    XTest{i+options.nlf} = XTestTemp{i};
end


% Creates the model
model = multigpCreate(q, d, X, y, options);

display = 1;
iters = 100;
model = multigpOptimise(model, display, iters);

% Prediction
mu = multigpPosteriorMeanVar(model, XTest);
maerror = mean(abs((yTestTemp{1} - mu{model.nlf + 1})));

%======visualize and save data=========
mean(abs(mu{2}-yTestTemp{1}))
mean(abs(mu{3}-yTestTemp{2}))
mean(abs(mu{4}-yTestTemp{3}))

save('demGgJura1-1.mat', 'model');

