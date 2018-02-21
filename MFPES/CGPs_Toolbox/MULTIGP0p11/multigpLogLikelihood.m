function  ll = multigpLogLikelihood( model)

% MULTIGPLOGLIKELIHOOD Compute the log likelihood of a MULTIGP.
%
%	Description:
%	ll = multigpLogLikelihood( model)
%% 	multigpLogLikelihood.m SVN version 230
% 	last update 2009-02-09T16:28:08.000000Z
% COPYRIGHT : Mauricio A Alvarez, 2008


switch model.approx
    case 'ftc'
        dim = size(model.m, 1);
        ll = -dim*log(2*pi) - model.logDetK - model.m'*model.invK*model.m;
        ll = ll*0.5;
        % MAP optimization for gpsim with more than two latent functions
%         if strcmp(model.kernType, 'sim') && (model.nlf>1) && ...
%                 strcmp(model.inference, 'map')
%             ll = ll - sum(log(model.S));
%         end
    case {'dtc','fitc','pitc'}
        ll = spmultigpLogLikelihood( model);

end
    
