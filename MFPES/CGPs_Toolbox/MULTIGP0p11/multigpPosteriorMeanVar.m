function [mu, varsig] = multigpPosteriorMeanVar(model, X, computeAll)

% MULTIGPPOSTERIORMEANVAR gives mean and variance of the posterior distribution.
%
%	Description:
%
%	[MU, VARSIG] = MULTIGPPOSTERIORMEANVAR(MODEL, X) gives the mean and
%	variance of outputs for the multi-output Gaussian process.
%	 Returns:
%	  MU - cell array containing mean posterior vectors.
%	  VARSIG - cell array containing the variance posterior vector
%	 Arguments:
%	  MODEL - the model for which posterior is to be computed.
%	  X - cell array containing locations where outputs are to be
%	   computed.
%	DESC gives the mean and variance of outputs for the multi-output
%	Gaussian process.
%	ARG model : the model for which posterior is to be computed.
%	ARG X : cell array containing locations where outputs are to be computed.
%	ARG computeAll : a flag to indicate if mean posterior for outputs are to
%	be computed. It is true by default.
%	RETURN mu : cell array containing mean posterior vectors.
%	RETURN varsig : cell array containing the variance posterior vector
%	
%	
%	
%	
%
%	See also
%	GPPOSTERIORMEANVAR


%	Copyright (c) 2008, 2009 Mauricio A Alvarez
%	Copyright (c) 2008 Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	multigpPosteriorMeanVar.m SVN version 384
% 	last update 2009-06-04T19:57:30.000000Z

% If computeAll is true, then compute posterior for latent forces and
% outputs. If computeAll is false, then compute posterior only for latent
% forces. This is introduced particularly for applications in which the
% number of outputs >> number of latent forces and we are only interested
% in latent forces posteriors.
if nargin<3
    computeAll = true;
end

% If X is a vector assume it applies for all outputs.
if ~iscell(X)
    xtemp = X;
    X = cell(1, model.d);
    for i = 1:model.d
        X{i} = xtemp;
    end
end

switch model.approx
    case 'ftc'
        mu = cell(model.d,1);
        varsig = cell(model.d,1);
        KX_star = kernCompute(model.kern, model.X, X);
        % Again, this is a bit of a hack to allow the inclusion of the
        % latent structure in the kernel structure.
        if sum(cellfun('length',model.X)) == model.N,
            base = 0;
        else
            base = model.nlf;
        end
        KX_star = KX_star(base+1:end,:);
        muTemp = KX_star'*model.alpha;
        diagK = kernDiagCompute(model.kern, X);
        Kinvk = model.invK*KX_star;
        varsigTemp = diagK - sum(KX_star.*Kinvk, 1)';
        if isfield(model, 'meanFunction') && ~isempty(model.meanFunction)
            m = meanCompute(model.meanFunction, X, model.nlf);
        end
        startVal=1;
        endVal=0;
        for i=1:length(X)
            endVal = endVal + size(X{i},1);
            if isfield(model, 'meanFunction') && ~isempty(model.meanFunction)
                mu{i}  = muTemp(startVal:endVal, 1)*model.scale(i) ...
                    + m(startVal:endVal, 1)+ model.bias(i);
            else
                mu{i}  = muTemp(startVal:endVal, 1)*model.scale(i) + model.bias(i);
            end
            varsig{i} = varsigTemp(startVal:endVal, 1)*model.scale(i)*model.scale(i);
            startVal = endVal+1;
        end

    case {'dtc','fitc','pitc'}
        if computeAll
            mu = cell(model.nout+model.nlf,1);
            varsig = cell(model.nout+model.nlf,1);
        else
            mu = cell(model.nlf,1);
            varsig = cell(model.nlf,1);
        end
        Ku_star_u    = cell(model.nlf);
        KX_star_X2   = cell(model.nout,model.nlf);
        KX_star_Diag = cell(model.nout,1);
        % Precomputations
        for r = 1:model.nlf,
            Ku_star_u{r,1} = zeros(size(X{1},1), model.k);
            for c = 1: length(model.kern.comp)
                Ku_star_u{r,1} = Ku_star_u{r,1} + real(multiKernComputeBlock(model.kern.comp{c}, X{1}, model.X{r}, r, r));
            end
            for i =1:model.nout,
                KX_star_X2{i,r} = real(multiKernComputeBlock(model.kern.comp{r},  X{i},...
                    model.X{r}, i+model.nlf, r));
            end
        end
        % Compute the Kyy part
        for j =1:model.nout,
            KX_star_Diag{j} = zeros(size(X{j},1),1);
            for c = 1: length(model.kern.comp)
                KX_star_Diag{j} = KX_star_Diag{j} + real(kernDiagCompute(model.kern.comp{c}.comp{j+model.nlf}, X{j}));
            end
        end
        KuuinvAinv = cell(model.nlf);
        for r =1:model.nlf,
            for q =1:model.nlf,
                if r ==q,
                    KuuinvAinv{r,q} = model.Kuuinv{r} - model.Ainv{r,r};
                else
                    KuuinvAinv{r,q} = -model.Ainv{r,q};
                end
            end
        end
        % Posterior for the latent functions
        for j=1:model.nlf
            mu{j} = Ku_star_u{j}*model.AinvKuyDinvy{j};
            varsig{j} = diag(Ku_star_u{j}*model.Ainv{j,j}*Ku_star_u{j}');% This is because we are only interested in the variances
        end
        % Posterior for the output functions
        if computeAll
            if isfield(model, 'meanFunction') && ~isempty(model.meanFunction)
                m = meanCompute(model.meanFunction, mat2cell(ones(model.nout,1), ones(model.nout,1), 1), 0);
            end
            DinvKyuAinv = cell(model.nlf,1);
            for i=1:model.nout,
                DinvKyuAinvKuyDinvy = zeros(size(model.X{i+model.nlf},1),1);
                mux_star = zeros(size(X{i},1),1);
                Kx_starXu = zeros(size(X{i},1));
                for r =1:model.nlf,
                    DinvKyuAinv{r} = zeros(size(model.X{i+model.nlf},1),model.k);
                    for q =1:model.nlf,
                        Kx_starXu = Kx_starXu + KX_star_X2{i,r}*KuuinvAinv{r,q}*KX_star_X2{i,q}';
                        DinvKyuAinv{r} = DinvKyuAinv{r} + model.KuyDinv{q,i}'*model.Ainv{q,r};
                    end
                    mux_star = mux_star + KX_star_X2{i,r}*model.AinvKuyDinvy{r};
                    DinvKyuAinvKuyDinvy = DinvKyuAinvKuyDinvy + model.KuyDinv{r,i}'*model.AinvKuyDinvy{r};
                end
                DinvKyuAinvKuyDinv = zeros(size(model.X{i+model.nlf},1));
                DinvKyuAinvKuyStar = zeros(size(model.X{i+model.nlf},1), size(X{i},1));
                for r =1:model.nlf,
                    DinvKyuAinvKuyDinv = DinvKyuAinvKuyDinv +  DinvKyuAinv{r}*model.KuyDinv{r,i};
                    DinvKyuAinvKuyStar = DinvKyuAinvKuyStar +  DinvKyuAinv{r}*KX_star_X2{i,r}';
                end
                if model.includeInd
                    c = length(model.kern.comp);
                    if model.includeNoise
                        c = c - 1;
                    end
                    Kw_star_x2 = real(multiKernComputeBlock(model.kern.comp{c}, X{i}, model.X{i+model.nlf}, i+model.nlf, i+model.nlf));
                    Kw_star_fDinvKyuAinvKuyStar = Kw_star_x2*DinvKyuAinvKuyStar;
                    Kw_star_fKyyinvKfw_star = Kw_star_x2*(model.Dinv{i} - DinvKyuAinvKuyDinv)*Kw_star_x2';
                    covInd = Kw_star_fDinvKyuAinvKuyStar + Kw_star_fDinvKyuAinvKuyStar' + Kw_star_fKyyinvKfw_star;
                    muInd = Kw_star_x2*(model.Dinv{i}*model.m{i} - DinvKyuAinvKuyDinvy);
                    mux_star = mux_star + muInd;
                end
                switch model.kernType
                    case {'gg','ggwhite'}
                        mu{i+model.nlf} = mux_star*model.scale(i) + model.bias(i);
                    otherwise
                        if isfield(model, 'meanFunction') && ~isempty(model.meanFunction)
                            mu{i+model.nlf} = mux_star*model.scale(i) + m(i) + model.bias(i);
                        else
                            mu{i+model.nlf} = mux_star*model.scale(i) + model.bias(i);
                        end
                end
                if nargout == 2
                    if model.includeInd
                        if isfield(model, 'beta') && ~isempty(model.beta)
                            varsig{i+model.nlf} = (KX_star_Diag{i} - diag(Kx_starXu) - diag(covInd) + 1/model.beta(i))*model.scale(i)*model.scale(i);
                        else
                            varsig{i+model.nlf} = (KX_star_Diag{i} - diag(Kx_starXu) - diag(covInd))*model.scale(i)*model.scale(i);
                        end
                    else
                        if isfield(model, 'beta') && ~isempty(model.beta)
                            varsig{i+model.nlf} = (KX_star_Diag{i} - diag(Kx_starXu) + 1/model.beta(i))*model.scale(i)*model.scale(i);
                        else
                            varsig{i+model.nlf} = (KX_star_Diag{i} - diag(Kx_starXu))*model.scale(i)*model.scale(i);
                        end
                    end
                end
            end
        end
    otherwise
        error('multigpPosteriorMeanVar not yet implemented');
end




