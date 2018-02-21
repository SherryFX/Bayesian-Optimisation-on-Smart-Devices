function [kern, noise, gpInfo] = gpDeconstruct(model)

% GPDECONSTRUCT break GP in pieces for saving.
%
%	Description:
%
%	[KERN, NOISE, GPINFO] = GPDECONSTRUCT(MODEL) takes an GP model
%	structure and breaks it into component parts for saving.
%	 Returns:
%	  KERN - the kernel component of the GP model.
%	  NOISE - the noise component of the GP model.
%	  GPINFO - a structure containing the other information from the GP:
%	   what the sparse approximation is, what the inducing variables are.
%	 Arguments:
%	  MODEL - the model that needs to be saved.
%	
%
%	See also
%	GPRECONSTRUCT


%	Copyright (c) 2007, 2009 Neil D. Lawrence
% 	gpDeconstruct.m SVN version 178
% 	last update 2009-01-08T13:47:00.000000Z

kern = model.kern;
if isfield(model, 'noise')
  noise = model.noise;
else
  noise = [];
end
gpInfo.learnScales = model.learnScales;
gpInfo.approx = model.approx;
switch model.approx
 case 'ftc'
 case {'dtc', 'dtcvar', 'fitc', 'pitc'}
  gpInfo.beta = model.beta;
  gpInfo.betaTransform = model.betaTransform;
  gpInfo.fixInducing = model.fixInducing;
  if model.fixInducing
    gpInfo.inducingIndices = model.inducingIndices;
  else
    gpInfo.X_u = model.X_u;
  end
end
gpInfo.type = 'gp';
gpInfo.scale = model.scale;
gpInfo.bias = model.bias;
gpInfo.d = model.d;
gpInfo.q = model.q;
gpInfo.k = model.k;
gpInfo.N = model.N;