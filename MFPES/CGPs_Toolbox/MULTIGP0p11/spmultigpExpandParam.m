function model = spmultigpExpandParam(model, params)

% SPMULTIGPEXPANDPARAM Expand a parameter vector into a SPMULTIGP model.
%
%	Description:
%
%	MODEL = SPMULTIGPEXPANDPARAM(MODEL, PARAMS) expands the model
%	parameters to a structure containing the information about a sparse
%	multi-output Gaussian process.
%	 Returns:
%	  MODEL - the model structure containing the information about the
%	   sparse model updated with the new parameter vector.
%	 Arguments:
%	  MODEL - the sparse model structure containing the information
%	   about the model.
%	  PARAMS - a vector of parameters from the model.
%	
%	
%
%	See also
%	MULTIGPCREATE, SPMULTIGPEXTRACTPARAM, MULTIGPEXTRACTPARAM, 


%	Copyright (c) 2008 Mauricio Alvarez
% 	spmultigpExpandParam.m SVN version 267
% 	last update 2009-03-04T09:28:00.000000Z


model.X_u = reshape(params, model.k, model.q);
for i = 1:model.nlf
    model.X{i} = model.X_u;
end




