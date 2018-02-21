
% DEMSPGP1D1 Do a simple 1-D regression after Snelson & Ghahramani's example.
%
%	Description:
%	% 	demSpgp1d1.m CVS version 1.3
% 	demSpgp1d1.m SVN version 133
% 	last update 2008-11-05T10:42:06.000000Z

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'spgp1d';
experimentNo = 1;

% load data
[X, y] = mapLoadData(dataSetName);

% Set up model
options = gpOptions('dtc');
options.numActive = 9;
options.optimiser = 'conjgrad';

% use the deterministic training conditional.
q = size(X, 2);
d = size(y, 2);

model = gpCreate(q, d, X, y, options);
model.X_u = randn(9, 1)*0.25 - 0.75;
params = gpExtractParam(model);
model = gpExpandParam(model, params);

% Optimise the model.
iters = 1000;
display = 1;

model = gpOptimise(model, display, iters);

% Save the results.
capName = dataSetName;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'model');


demSpgp1dPlot
