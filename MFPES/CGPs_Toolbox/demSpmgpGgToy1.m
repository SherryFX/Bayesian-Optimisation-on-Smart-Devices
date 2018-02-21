
% DEMSPMGPGGTOY1 Demonstrate sparse multigp on TOY data using the PITC
%
%	Description:
%	approximation
% 	demSpmgpGgToy1.m SVN version 400
% 	last update 2009-06-10T20:54:00.000000Z
% In this demo, we use the Gaussian Kernel for all the covariances 
% (or Kernels) involved and only one hidden function.


rand('twister', 1e6);
randn('state', 1e6);

dataSetName = 'ggToy';
experimentNo = 2;

[XTemp, yTemp, XTestTemp, yTestTemp] = mapLoadData(dataSetName);

options = multigpOptions('fitc');
options.kernType = 'gg';
options.optimiser = 'scg';
options.nlf = 1;
options.initialInducingPositionMethod = 'espaced';
options.numActive = 30;
options.beta = 1e-3*ones(1, size(yTemp, 2));
options.fixInducing = false;

X = cell(size(yTemp, 2),1);
y = cell(size(yTemp, 2),1);

for i = 1:size(yTemp, 2)
  y{i} = yTemp{i};
  X{i} = XTemp{i};
end

q = 1;
d = size(yTemp, 2);

% Creates the model
model = multigpCreate(q, d, X, y, options);

display = 1;
iters = 2000;

% Train the model 
init_time = cputime; 
model = multigpOptimise(model, display, iters);
elapsed_time = cputime - init_time;

% Save the results.
capName = dataSetName;
capName(1) = upper(capName(1));
save(['demSpmgp' capName num2str(experimentNo) '.mat'], 'model');

ggSpmgpToyResults(dataSetName, experimentNo, XTemp, yTemp);

