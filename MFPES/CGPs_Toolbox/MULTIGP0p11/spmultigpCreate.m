function model = spmultigpCreate(model, options)

% SPMULTIGPCREATE
%
%	Description:
%	DESC incorporates into de model options retaled with the sparse methods
%	RETURN model : the structure for the sparse multigp model
%	ARG model : input sparse model.
%	ARG options : contains the options for the sparse multigp model
% 	spmultigpCreate.m SVN version 267
% 	last update 2009-03-04T09:28:00.000000Z
% COPYRIGHT : Mauricio Alvarez  2008


switch options.approx
    case {'dtc','fitc', 'pitc'}
        % Sub-sample inducing variables.
        model.k = options.numActive;
        model.fixInducing = options.fixInducing;
        model.X_u = model.X{1};
end

% Yehong: why cannot be greater?
% if model.k>model.N
%     error('Number of active points cannot be greater than number of data.')
% end
