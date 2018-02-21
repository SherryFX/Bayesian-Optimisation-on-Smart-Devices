function options = multigpOptions(approx)

% MULTIGPOPTIONS Return default options for the MOCAP examples in the LFM model.
%
%	Description:
%
%	OPTIONS = MULTIGPOPTIONS(APPROX) returns the default options in a
%	structure for a MULTIGP model.
%	 Returns:
%	  OPTIONS - structure containing the default options for the given
%	   approximation type.
%	 Arguments:
%	  APPROX - approximation type, either 'none' (no approximation),
%	   'fitc' (fully independent training conditional) or 'pitc'
%	   (partially independent training conditional.
%	
%	
%
%	See also
%	MULTIGPCREATE


%	Copyright (c) 2008 Mauricio Alvarez
%	Copyright (c) 2008 Neil D. Lawrence
% 	multigpOptions.m SVN version 312
% 	last update 2009-04-08T10:39:37.000000Z

  options.type = 'multigp';
  
  if nargin<1
    options.approx = 'ftc';
  else
    options.approx = approx;
  end
  % Basic kernel
  options.kernType = 'gg';
  % Include noise in the model
  options.includeNoise = true;
  %Learn the scales
  options.learnScales = false;
  % Include independent kernel in the model
  options.includeInd = false;
  % Include options to tie the parameters
  options.tieOptions = multigpTieOptions;
  % Method for optimization
  options.optimiser = 'scg';
  % One latent function.
  options.nlf = 1;
  
  % Set to a given mean function to have a mean function.
  options.meanFunction = [];
  % Options structure for mean function options.
  options.meanFunctionOptions = [];
  
  
  
  switch options.approx
   case 'ftc'
    options.numActive = [];
   case {'dtc','fitc','pitc'}
    options.numActive = 15;
    options.fixInducing = true;
    options.fixIndices = 1:options.numActive;
    options.includeScalesp = 0;
    if strcmp(options.approx, 'dtc')
        options.beta = 1e-3;
    else
        options.beta = 1e3;
    end
    % Initial position of the inducing variables. Options are 'random',
    % in which random initial locations taken from the used data;
    % 'espaced' the initial locations are equally spaced chosen across
    % all dimensions; 'fixIndices' the indices in the fixIndices
    % options are employed; 'kmeans' the kmeans method gives the
    % initial positions.        
    options.initialInducingPositionMethod = 'random'; 
  end
end


function options = multigpTieOptions
  options.tieIndices = false;
  options.selectMethod = 'free';
end

