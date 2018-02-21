function ll = spmultigpLogLikelihood( model)

% SPMULTIGPLOGLIKELIHOOD Compute the log likelihood of a SPARSE MULTIGP.
%
%	Description:
%
%	LL = SPMULTIGPLOGLIKELIHOOD(MODEL) log likelihood in the sparse
%	multigp model
%	 Returns:
%	  LL - log likelihood for the sparse multigp model
%	 Arguments:
%	  MODEL - the model structure containing the sparse model
%	


%	Copyright (c) 2008 Mauricio A Alvarez
% 	spmultigpLogLikelihood.m SVN version 267
% 	last update 2009-03-04T09:28:00.000000Z

ll = model.N*log(2*pi);
for k = 1: model.nout,
    ll = ll + model.logDetD{k}; % contribution of ln det D
    switch model.approx
        case 'dtc'
            ll = ll + model.beta(k)*sum(model.m{k}.^2); % contribution of trace(inv D yy')           
        case {'fitc','pitc'}
            ll = ll + trace(model.Dinv{k}*model.m{k}*model.m{k}'); % contribution of trace(inv D yy')
    end
end
for r = 1:model.nlf, % contribution of ln det Kuu
    ll = ll - model.logDetKuu{r};
end
ll = ll + model.logDetA; % contribution of ln det A
for k =1: model.nlf, % contribution of trace(invD Kyu invA Kuy invD yy')
    for r = 1:model.nlf,
        ll = ll - trace(model.KuyDinvy{k}'*model.Ainv{k,r}*model.KuyDinvy{r});
    end
end

if strcmp(model.approx,'dtc')
    for k = 1:model.nout
        ll = ll + model.beta(k)*sum(model.Ktilde{k});       
    end
end

ll = -0.5*ll;

