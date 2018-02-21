function [model, fmin, params] = multigpOptimise(model, display, iters)

% MULTIGPOPTIMISE Optimise the inducing variable multigp based kernel.
%
%	Description:
%
%	[MODEL, PARAMS] = MULTIGPOPTIMISE(MODEL, DISPLAY, ITERS) optimises
%	the Gaussian process  model for a given number of iterations.
%	 Returns:
%	  MODEL - the optimised model.
%	  PARAMS - the optimised parameter vector.
%	 Arguments:
%	  MODEL - the model to be optimised.
%	  DISPLAY - whether or not to display while optimisation proceeds,
%	   set to 2 for the most verbose and 0 for the least verbose.
%	  ITERS - number of iterations for the optimisation.
%	multigpOptimiseGradient, multigpOptimiseObjective
%	
%	
%
%	See also
%	SCG, CONJGRAD, MULTIGPOPTIMISECREATE, 


%	Copyright (c) 2005, 2006 Neil D. Lawrence


%	With modifications by Mauricio A. Alvarez 2008
% 	multigpOptimise.m SVN version 267
% 	last update 2009-03-04T09:28:00.000000Z

if nargin < 3
  iters = 1000;
  if nargin < 2
    display = 1;
  end
end

params = modelExtractParam(model);

options = optOptions;
if display
  options(1) = 1;
  if length(params) <= 100 && display > 1
    options(9) = 1;
  end
end
options(14) = iters;

if isfield(model, 'optimiser')
  optim = str2func(model.optimiser);
else
  optim = str2func('conjgrad');
end

if strcmp(func2str(optim), 'optimiMinimize')
  % Carl Rasmussen's minimize function 
  params = optim('multigpObjectiveGradient', params, options, model);
else
  % NETLAB style optimization.
  [params, options] = optim('multigpObjective', params,  options, ...
                 'multigpGradient', model);
end

%model = multigpExpandParam(model, params);

model = modelExpandParam(model, params);
model.params = params;
fmin = options(8);


