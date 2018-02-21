function [params, names] = spmultigpExtractParam(model, paramPart, names)

% SPMULTIGPEXTRACTPARAM Extract a parameter vector from a sparse MULTIGP model.
%
%	Description:
%
%	PARAMS = SPMULTIGPEXTRACTPARAM(MODEL, PARAMPART) extracts the model
%	parameters from a structure containing the information about a
%	sparse multi-output Gaussian process.
%	 Returns:
%	  PARAMS - a vector of parameters from the model.
%	 Arguments:
%	  MODEL - the model structure containing the information about the
%	   model.
%	  PARAMPART - the parameters corresponding to the sparse part of the
%	   multigp model
%	DESC extracts the model parameters from a structure containing
%	the information about a sparse multi-output Gaussian process.
%	ARG model : the model structure containing the information about
%	the model.
%	ARG paramPart: the parameters corresponding to the sparse part of the
%	multigp model
%	ARG names : cell array correspondig to the names of the basic multigp
%	model structure.
%	RETURN params : a vector of parameters from the model.
%	RETURN names : cell array of parameter names.
%	
%	
%
%	See also
%	MULTIGPCREATE, MULTIGPEXPANDPARAM, MODELEXTRACTPARAM


%	Copyright (c) 2008 Mauricio A Alvarez
% 	spmultigpExtractParam.m SVN version 267
% 	last update 2009-03-04T09:28:00.000000Z

switch model.approx
    case {'dtc','fitc', 'pitc'}
        if model.fixInducing
            params = paramPart;
            model.X_u = model.X{1};
        else
            model.X_u = model.X{1};    
            params =  [paramPart model.X_u(:)'];
            X_uNames = cell(size(model.X_u));
            if nargout>1
                for i = 1:size(model.X_u, 1)
                    for j = 1:size(model.X_u, 2)
                        X_uNames{i, j} = ['X_u (' num2str(i) ', ' num2str(j) ')'];
                    end
                end
                names = {names{:}, X_uNames{:}};
            end
        end
    otherwise
        %
end