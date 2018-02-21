
% DEMTOY4 Demo of Full Multi Output Gaussian Process. In this demo, we use the Gaussian Kernel for all the covariances (or Kernels) involved and only one hidden function.
%
%	Description:
%	% 	demToy4.m SVN version 18
% 	last update 2008-06-06T20:40:39.000000Z

% When changing the kernel, the fix values in this code and the indeces in
% the tieParam vector in multigpCreate must also be changed.

clc
clear
rand('seed',1e6);
randn('seed',1e6);
%
dataSetName = 'sample1D41';
experimentNo = 1;
approx = 'ind';
ntrainX =200;
iters =1000;
saveFigures=1;
% load data
data = multigpLoadData(dataSetName);
data.nin = 1;  % Number of latent functionsmissingData = cell(data.nout,1);
missingData{1} = 21:90;

data.nin = 1;  % Number of latent functions
data.nout = 1 ;
data.Y = data.Y(:,4);
data.F = data.F(:,4);
data.y = data.Y(:);

options.isSparse = 0;      % Indicates if the scheme is sparse (1) or if it is full (0)
options.stdBiasX = 0;      % Indicates if the inputs are to be standarized (1) or not(0)
options.stdBiasY = 0;      % Indicates if the outputs are to be standarized (1) or not(0)
options.outKernelName = 'gg'; % Indicates the name of the output kernel: lfm, sim or gg
% Setup model
[options, MXtrain, Xtrain, MYtrain, Ytrain, Xtest, Ytest] = multigpOptionsToy(options, data, ntrainX, missingData);
options.optimiser = 'scg';
% Creates the model
model = multigpCreate(MYtrain, MXtrain, options);

% Trains the model and counts the training time
ini_t = cputime;
[model, params] = multigpOptimise(model,1,iters);
total_t = cputime - ini_t;

% This part is to show the plots of the mean prediction and error bars
Xt = linspace(min(Xtrain{1})-0.2,max(Xtrain{1})+0.2,500)';
[mu, varsigma] = multigpPredictionMeanVar(model, Xt, options);
close all
xlim = [-1.2 1.2];
for k=1:model.nout,
    figure
    hold on
    f = [mu{k}+2*real(sqrt(varsigma{k}));flipdim(mu{k}-2*real(sqrt(varsigma{k})),1)];
    a = fill([Xt; flipdim(Xt,1)], f, [7 7 7]/8, 'EdgeColor', [7 7 7]/8);
    a =[ a plot(data.x, data.F(:,k), 'k--')];
    a =[ a plot(Xt, mu{k},'k-')];
    c =plot(Xtrain{k},Ytrain{k},'k.');
    minimum = min(mu{k}-2*real(sqrt(varsigma{k})));
    maximum = max(mu{k}+2*real(sqrt(varsigma{k})));
    if isfield(model, 'X_u') && ~isempty(model.X_u);
        b = plot(model.X_u, minimum -10, 'kx');
        set(b, 'linewidth', 2)
        set(b, 'markersize', 10);
    end
    ylim = [-10 10];
    set(a,   'lineWidth', 2);
    set(c,   'markersize', 10);
    set(gca, 'fontname', 'arial', 'fontsize', 15, 'xlim', xlim, 'ylim', ylim, 'Color', 'none')
    box on
    if saveFigures==1
        fileName = ['Toy_prediction' approx num2str(k)];
        print('-depsc', ['./results/' fileName]);
        pos = get(gcf, 'paperposition');
        origpos = pos;
        pos(3) = pos(3)/2;
        pos(4) = pos(4)/2;
        set(gcf, 'paperposition', pos);
        lineWidth = get(gca, 'lineWidth');
        set(gca, 'lineWidth', lineWidth);
        print('-dpng', ['./results/' fileName])
        set(gca, 'lineWidth', lineWidth);
        set(gcf, 'paperposition', origpos);
    end
end






