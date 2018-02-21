function g = meanGradient(meanFunction, varargin)

% MEANGRADIENT Gradient of the parameters of the mean function in the
%
%	Description:
%	multigp model
%
%	G = MEANGRADIENT(MEANFUNCTION, ...) gives the gradient of the
%	objective function for the parameters of the mean function in the
%	multigp model
%	 Returns:
%	  G - the gradient of the error function to be minimised.
%	 Arguments:
%	  MEANFUNCTION - mean function structure to optimise.
%	  ... - optional additional arguments.
%	
%
%	See also
%	MEANCREATE, MEANCOMPUTE


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	meanGradient.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

fhandle = str2func([meanFunction.type 'MeanGradient']);
g = fhandle( meanFunction, varargin{:});

factors = meanFactors(meanFunction, 'gradfact');
g(factors.index) = g(factors.index).*factors.val;

