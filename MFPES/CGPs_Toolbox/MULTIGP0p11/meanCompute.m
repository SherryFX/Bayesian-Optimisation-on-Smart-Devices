function m = meanCompute(meanFunction, X, varargin)

% MEANCOMPUTE Give the output of the lfm mean function model for given X.
%
%	Description:
%
%	Y = MEANCOMPUTE(MEANFUNCTION, X) gives the output of a mean function
%	model for a given input X.
%	 Returns:
%	  Y - output location(s) corresponding to given input locations.
%	 Arguments:
%	  MEANFUNCTION - structure specifying the model.
%	  X - input location(s) for which output is to be computed.
%	
%
%	See also
%	MEANCREATE


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	meanCompute.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

fhandle = str2func([meanFunction.type 'MeanCompute']);
m = fhandle(meanFunction, X, varargin{:});
