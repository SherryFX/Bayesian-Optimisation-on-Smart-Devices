
% GGMOBILETF Demo of full multi output GP with missing data.

% clc
clear
rand('twister',1e6);
randn('state',1e6);

dataSetName = 'mobileTF'; % To be replaced with MobileTF data
experimentNo = 1;

% tar = csvread("/Users/HFX/Desktop/Bayesian Optimization on Smart Devices/MFPES/res/target_res.csv", 1, 0);
% aux = xlsread("/Users/HFX/Desktop/Bayesian Optimization on Smart Devices/MFPES/res/auxiliary_res_merged.xlsx");

load('EMINIST_dataset_mean_thres_norm_ratio');

XTemp =  cell([1 2]);
XTemp{1} = mainFiltered(:, 1:5);
XTemp{2} = mainFiltered(:, 1:5);
yTemp =  cell([1 2]);
yTemp{1} = -log(tarRatio); %-logTarRatio; %tarRatio; %normTarRatio;
yTemp{2} = -log(auxRatio/4); %-scaledLogAuxRatio; %auxRatio; %normAuxRatio;

options = multigpOptions('ftc');
options.kernType = 'gg';
options.optimiser = 'scg';
options.nlf = 1; % NO. of latent function (1)
options.M = 2; % No. of output types

q = 5; % Input dimension
d = size(yTemp, 2) + options.nlf;

X = cell(size(yTemp, 2)+options.nlf,1);
y = cell(size(yTemp, 2)+options.nlf,1);

% When we want to include the structure of the latent force kernel within
% the whole kernel structure, and we don't have access to any data from the
% latent force, we just put ones in the vector X and empty in the vector y.


for j=1:options.nlf
   y{j} = [];
   X{j} = zeros(1, q);  
end

% ord = randperm(532);
% for i = 1:size(yTemp, 2)
%   y{i+options.nlf} = yTemp{i}(ord, :);
%   XTemp{i} = XTemp{i}(ord, :);
%   X{i+options.nlf} = transX(XTemp{i}, 'mobile', false);    
% end

for i = 1:size(yTemp, 2)
  y{i+options.nlf} = yTemp{i};
  X{i+options.nlf} = transX(XTemp{i}, 'mobile', false);    
end

% Creates the model
model = multigpCreate(q, d, X, y, options);

% Initialisation
params = modelExtractParam(model);
for i =1:options.M
    for j =1:model.q
        index = paramNameRegularExpressionLookup(model,['multi .* ' num2str(i) ...
            ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);

        if size(model.X{model.nlf + i}, 1) == 1
            avgLengthScale = abs(rand)*(xmax(j)-xmin(j));
        else
            avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + i}(:,j)))));
        end
        params(index) = log(2) - 2*log(0.1*avgLengthScale) + log(abs(randn));
%                 params(index) = rand+log(1000);
    end
end
model = modelExpandParam(model, params);
% Change the inverse width of the latent functions
params = modelExtractParam(model);
for i=1:model.nlf
    for j =1:model.q
        index = paramNameRegularExpressionLookup(model,['multi ', num2str(i),' .* ', num2str(i) ...
            ' inverse width latent \(' num2str(j) ',' num2str(j) '\)']);

        if size(model.X{model.nlf+i}, 1) == 1
            avgLengthScale = rand*(xmax(j)-xmin(j));
        else
            avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf+i}(:,j)))));
        end
        params(index) = log(2) - 2*log(avgLengthScale) + log(abs(randn));
%             params(index) = rand + log(10*rand);
    end
end
model = modelExpandParam(model, params);


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
