
% DEMGGTOY1 Demo of full multi output GP with missing data.
%
%	Description:
%	% 	demGgToy1.m SVN version 289
% 	last update 2009-03-04T20:54:21.000000Z


% clc
clear
rand('twister',1e6);
randn('state',1e6);

dataSetName = 'ggToy';
experimentNo = 1;

[XTemp, yTemp, XTestTemp, yTestTemp] = mapLoadData(dataSetName);

options = multigpOptions('ftc');
options.kernType = 'gg';
options.optimiser = 'scg';
options.nlf = 1;

q = 1; % Input dimension
d = size(yTemp, 2) + options.nlf;

X = cell(size(yTemp, 2)+options.nlf,1);
y = cell(size(yTemp, 2)+options.nlf,1);

% When we want to include the structure of the latent force kernel within
% the whole kernel structure, and we don't have access to any data from the
% latent force, we just put ones in the vector X and empty in the vector y.

  yTemp{2} = -yTemp{2};
  yTemp{4} = -yTemp{4};


for j=1:options.nlf
   y{j} = [];
   X{j} = zeros(1, q);  
end
for i = 1:size(yTemp, 2)
  y{i+options.nlf} = yTemp{i};
  X{i+options.nlf} = XTemp{i};
end

% Creates the model
model = multigpCreate(q, d, X, y, options);

display = 1;
iters = 1000;

% Trains the model 
init_time = cputime;
model = multigpOptimise(model, display, iters);
elapsed_time = cputime - init_time;

% Save the results.
capName = dataSetName;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'model');

ggToyResults(dataSetName, experimentNo, XTemp, yTemp);

