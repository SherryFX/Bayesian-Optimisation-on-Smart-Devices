function g = multigpGradient(params, model)

% MULTIGPGRADIENT Gradient wrapper for a MULTIGP model.
%
%	Description:
%	g = multigpGradient(params, model)
%% 	multigpGradient.m SVN version 153
% 	last update 2008-11-28T10:12:58.000000Z

model = modelExpandParam(model, params);
g = - modelLogLikeGradients(model);
%g = - multigpLogLikeGradients(model);
