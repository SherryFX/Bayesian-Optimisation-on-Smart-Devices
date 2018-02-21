function f = multigpObjective(params, model)

% MULTIGPOBJECTIVE Wrapper function for MULTIGPOPTIMISE objective.
%
%	Description:
%	f = multigpObjective(params, model)
%% 	multigpObjective.m SVN version 153
% 	last update 2008-11-28T10:12:58.000000Z

model = modelExpandParam(model, params);
f = - multigpLogLikelihood(model);
