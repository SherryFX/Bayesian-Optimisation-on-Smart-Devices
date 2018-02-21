function g = simMeanGradient(meanFunction, varargin)

% SIMMEANGRADIENT Gradient of the parameters of the mean function in the
%
%	Description:
%	multigp model with SIM kernel
%
%	G = SIMMEANGRADIENT(MEANFUNCTION, ...) gives the gradient of the
%	objective function for the parameters of the mean function in the
%	multigp model with LFM kernel (second order differential equation).
%	 Returns:
%	  G - the gradient of the error function to be minimised.
%	 Arguments:
%	  MEANFUNCTION - mean function structure to optimise.
%	  ... - optional additional arguments.
%	
%
%	See also
%	SIMMEANCREATE, SIMMEANOUT


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	simMeanGradient.m SVN version 156
% 	last update 2008-11-30T22:05:55.000000Z

gmu = varargin{1}';
gB = gmu./meanFunction.decay;
gD = -gmu.*meanFunction.basal./(meanFunction.decay.*meanFunction.decay);
g = [gB' gD'];
