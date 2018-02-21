function g = lfmMeanGradient(meanFunction, varargin)

% LFMMEANGRADIENT Gradient of the parameters of the mean function in the
%
%	Description:
%	multigp model with LFM kernel
%
%	G = LFMMEANGRADIENT(MEANFUNCTION, ...) gives the gradient of the
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
%	LFMMEANCREATE, LFMMEANOUT


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	lfmMeanGradient.m SVN version 289
% 	last update 2009-03-04T20:54:21.000000Z

gmu = varargin{1}';
gB = gmu./meanFunction.spring;
gD = -gmu.*meanFunction.basal./(meanFunction.spring.*meanFunction.spring);
g = [gB' gD'];




                      