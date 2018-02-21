function [mu, varSig, ret_kx_star] = multigpPosteriorSinglef(model, X, type)

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

if nargin<3
    type = 0;
end

% If X is a vector assume it applies for all outputs.
if ~iscell(X)
    nX = size(X, 1);
    xtemp = X;
    X = cell(1, model.d);
    for i = 1:model.d
        X{i} = xtemp;
    end
    
    % Yehong: pitc
    X1 = cell(1, model.d+model.nlf);
    for i = 1:model.d+model.nlf
        X1{i} = xtemp;
    end
end

model.kern.type = 'cmpndno';

switch model.approx
    case 'ftc'
        KX_star = kernCompute(model.kern, model.X, X); %(M+nlf)*(M*|X|)
        Kstar = kernCompute(model.kern, X);     %((M+nlf)*|X|)*((M+nlf)*|X|)
 
        % Again, this is a bit of a hack to allow the inclusion of the
        % latent structure in the kernel structure.
        if sum(cellfun('length',model.X)) == model.N,
            base = 0;
        else
            base = model.nlf;
        end
        
        if type == 0
            KX_star = KX_star(base+1:end,:);    % N*(M*|X|)
            muTemp = KX_star'*model.alpha;      % (M+1)*1
            %diagK = kernDiagCompute(model.kern, X);
            varsigTemp = Kstar - KX_star' * model.invK * KX_star;

            muTemp = (muTemp' .* model.scale + model.bias)';
            varsigTemp = diag(model.scale)*varsigTemp*diag(model.scale);

            mu = muTemp(base+nX:end);
            varSig = varsigTemp(base+nX:end, base+nX:end);

            ret_kx_star = KX_star;
            
        else

            KX_star = KX_star(base+1:end, nX*(base+type-1)+1:nX*(base+type-1)+nX);    % N*|X|
            muTemp = KX_star'*model.alpha;      % |X|*1
            
            Kstar = Kstar(nX*(base+type-1)+1:nX*(base+type-1)+nX, nX*(base+type-1)+1:nX*(base+type-1)+nX); % |X|*|X|
            varsigTemp = Kstar - KX_star' * model.invK * KX_star;

            mu = muTemp * model.scale(type+base) + model.bias(type+base);
            varSig = model.scale(type+base).^2 * varsigTemp;

            ret_kx_star = KX_star;
        end

%     case {'dtc','fitc','pitc'}
%         Ku_star_u    = cell(model.nlf);
%         KX_star_X2   = cell(model.nout,model.nlf);
%         
%         % Precomputations
%         for r = 1:model.nlf,
%             Ku_star_u{r,1} = zeros(size(X{1},1), model.k);
%             for c = 1: length(model.kern.comp)
%                 Ku_star_u{r,1} = Ku_star_u{r,1} + real(multiKernComputeBlock(model.kern.comp{c}, X{1}, model.X{r}, r, r));
%             end
%             for i =1:model.nout,
%                 KX_star_X2{i,r} = real(multiKernComputeBlock(model.kern.comp{r},  X{i},...
%                     model.X{r}, i+model.nlf, r));
%             end
%         end
%         
%         % Compute the Kyy part
%         KX_star = kernCompute(model.kern, X1);
%         KX_star = KX_star(2:end, 2:end);
% 
%         KuuinvAinv = cell(model.nlf);
%         for r = 1:model.nlf,
%             for q = 1:model.nlf,
%                 if r == q,
%                     KuuinvAinv{r,q} = model.Kuuinv{r} - model.Ainv{r,r};
%                 else
%                     KuuinvAinv{r,q} = -model.Ainv{r,q};
%                 end
%             end
%         end
%         
%         KX_star_X2_all = zeros(model.nout, size(model.X_u, 1)); % Yehong: K_YU N*|U|
%         for i = 1:model.nout
%             KX_star_X2_all(i, :) = KX_star_X2{i,1};
%         end
% 
%         % Posterior for the output functions
%         if type == 0       
%             mu = zeros(model.nout,1);
%             Kx_starXu = zeros(model.nout, model.nout);
%             for r =1:model.nlf,
%                 for q =1:model.nlf,
%                     Kx_starXu = Kx_starXu + KX_star_X2_all*KuuinvAinv{r,q}*KX_star_X2_all';
%                 end
%                 mu = mu + KX_star_X2_all*model.AinvKuyDinvy{r};
%             end
%             
%             if nargout == 2
%                 varSig = KX_star - Kx_starXu;
%             end
%         end
%         
%         mu = (mu'.*model.scale + model.bias)';
%         
%         if isfield(model, 'beta') && ~isempty(model.beta)
%             varSig = diag(model.scale) * (varSig + diag(1/model.beta)) * diag(model.scale);
%         else
%             varSig = diag(model.scale) * varSig * diag(model.scale);
%         end
        
    otherwise
        error('multigpPosteriorSinglef not implemented yet');
end





