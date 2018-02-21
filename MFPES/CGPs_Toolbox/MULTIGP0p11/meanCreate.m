function  model = meanCreate(q, d, X, y, options)

% MEANCREATE creates the mean function for a multi output GP
%
%	Description:
%	
%
%	MODEL = MEANCREATE(Q, D, X, Y, OPTIONS) returns a structure for the
%	mean function for the multiple output Gaussian process model
%	 Returns:
%	  MODEL - the structure for the mean function of the multigp model
%	 Arguments:
%	  Q - input dimension size.
%	  D - output dimension size.
%	  X - set of training inputs
%	  Y - set of training observations
%	  OPTIONS - contains the options for the MEAN of the MULTIGP model.
%	SEE ALSO: meanCompute
%	


%	Copyright (c) 2008 Mauricio A. Alvarez and Neil D. Lawrence
% 	meanCreate.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

fhandle = str2func([options.type  'MeanCreate' ]);
model = fhandle(q , d, options);
model.paramGroups = speye(model.nParams);