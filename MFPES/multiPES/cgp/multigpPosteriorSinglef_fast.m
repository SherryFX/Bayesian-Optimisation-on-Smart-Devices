function [mu, varSig, ret_kx_star] = multigpPosteriorSinglef_fast(model, X, type)

% MULTIGPPOSTERIORNOISELESS gives mean and variance of the posterior distribution without noise.
%
%	Description:
%
%	 Returns:
%	  MU - vector containing the posterior mean
%	  VARSIG - posterior variance matrix
%	 Arguments:
%	  MODEL - the model for which posterior is to be computed.
%	  X - an input to be predicted
%	  type - type of ouptut (default 0: predict for all types of output)

base = model.nlf;

KX_star = kernComputeFast(model.X, X, type, model.hypers); %1*N
Kstar = kernComputeFast(X, X, type, model.hypers);     %1*1


muTemp = KX_star'*model.alpha;      % |X|*1
varsigTemp = Kstar - KX_star' * model.invK * KX_star;

mu = muTemp * model.scale(type+base) + model.bias(type+base);
varSig = model.scale(type+base).^2 * varsigTemp;

ret_kx_star = KX_star;
        





