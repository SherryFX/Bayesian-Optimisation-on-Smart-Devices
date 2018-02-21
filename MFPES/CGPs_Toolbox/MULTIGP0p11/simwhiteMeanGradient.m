function g = simwhiteMeanGradient(meanFunction, varargin)

% SIMWHITEMEANGRADIENT Gradient of the parameters of the mean function in
%
%	Description:
%	the multigp model with SIM-WHITE kernel.
%
%	G = SIMWHITEMEANGRADIENT(MEANFUNCTION, ...) gives the gradient of
%	the objective function for the parameters of the mean function in
%	the multigp model with SIM-WHITE kernel (second order differential
%	equation with white noise process input).
%	 Returns:
%	  G - the gradient of the error function to be minimised.
%	 Arguments:
%	  MEANFUNCTION - mean function structure to optimise.
%	  ... - optional additional arguments.
%	
%	
%
%	See also
%	SIMWHITEMEANCREATE, SIMWHITEMEANOUT


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	simwhiteMeanGradient.m SVN version 277
% 	last update 2009-03-04T20:54:27.000000Z

gmu = varargin{1}';
gB = gmu./meanFunction.decay;
gD = -gmu.*meanFunction.basal./(meanFunction.decay.*meanFunction.decay);
g = [gB' gD'];
