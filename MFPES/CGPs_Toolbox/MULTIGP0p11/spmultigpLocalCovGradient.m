function [dLdKyy, dLdKuy, dLdKuu, dLdmu, dLdbeta] = spmultigpLocalCovGradient(model)

% SPMULTIGPLOCALCOVGRADIENT Computes the derivatives of the likelihood
%
%	Description:
%	objective function corresponding to the sparse approximation, with
%	respect to the kernels of the multi output gp.
%	
% 	spmultigpLocalCovGradient.m SVN version 384
% 	last update 2009-06-04T19:57:30.000000Z
% COPYRIGHT : Mauricio A Alvarez, 2008


Ainv = cell2mat(model.Ainv);
AinvKuyDinvy = cell2mat(model.AinvKuyDinvy);
Kyu = cell2mat(model.Kyu);

C = mat2cell(Ainv + (AinvKuyDinvy*AinvKuyDinvy'), model.k*ones(1,model.nlf), model.k*ones(1,model.nlf));
CKuy = mat2cell(cell2mat(C)*Kyu', model.k*ones(1,model.nlf), cellfun('length',model.m));


switch model.approx
    case 'dtc'
        dLdKyy = cell(model.nout,1);
        for k=1:model.nout,
            dLdKyy{k} =  -0.5*model.Dinv{k};
        end
        dLdKuy = cell(model.nlf,model.nout);
        for r =1:model.nlf,
            for k= 1:model.nout,
                dLdKuy{r,k} = model.KuuinvKuy{r,k}*model.beta(k)...
                    - CKuy{r,k}*model.beta(k) + model.AinvKuyDinvy{r}*model.m{k}'*model.beta(k);               
            end
        end
        dLdKuu = cell(model.nlf,1);
        for r =1:model.nlf,
            KuuinvKuyQKyuKuuinv = zeros(model.k);
            dLdKuu{r} = zeros(model.k);
            for k=1: model.nout,              
                KuuinvKuyQKyuKuuinv =  KuuinvKuyQKyuKuuinv + model.KuuinvKuy{r,k}*model.Dinv{k}*model.KuuinvKuy{r,k}';
            end
            dLdKuu{r} = 0.5*((model.Kuuinv{r} - C{r,r}) - KuuinvKuyQKyuKuuinv);
        end
        dLdbeta = zeros(1,model.nout);
        dLdmu = cell(model.nout,1);
        for k =1:model.nout,
            DinvKyuAinvKuyDinvy = zeros(size(model.X{k+model.nlf},1),1);
            H = zeros(size(model.X{k+model.nlf},1));
            for r =1:model.nlf,
                H = H + model.Kyu{k,r}*model.AinvKuyDinvy{r}*model.m{k}'+ (model.Kyu{k,r}*model.AinvKuyDinvy{r}*model.m{k}')'...
                    - model.Kyu{k,r}*CKuy{r,k};
                DinvKyuAinvKuyDinvy = DinvKyuAinvKuyDinvy + model.KuyDinv{r,k}'*model.AinvKuyDinvy{r};
            end 
%             dLdbeta(k) = -0.5*model.beta(k)^(-2)*trace(model.Dinv{k}*(sparseDiag(model.Ktilde{k}) - ...
%                 (model.D{k} - model.m{k}*model.m{k}' + H))*model.Dinv{k});
            dLdbeta(k) = -0.5*(sum(model.Ktilde{k}) - (size(model.X{k+model.nlf},1)*1/model.beta(k) - model.m{k}'*model.m{k} + trace(H)));
            if ~strcmp(model.kernType,'gg')
                dLdmu{k} = model.beta(k)*model.m{k} - DinvKyuAinvKuyDinvy;
            end
        end
    case {'fitc','pitc'}
        Q = cell(model.nout,1);
        dLdKyy = cell(model.nout,1);
        dLdmu = cell(model.nout,1);
        for k =1:model.nout,
            DinvKyuAinvKuyDinvy = zeros(size(model.X{k+model.nlf},1),1);
            Q{k} = zeros(size(model.X{k+model.nlf},1));
            for r =1:model.nlf,
                Q{k} = Q{k} + model.Kyu{k,r}*model.AinvKuyDinvy{r}*model.m{k}'...
                    + (model.Kyu{k,r}*model.AinvKuyDinvy{r}*model.m{k}')' - model.Kyu{k,r}*CKuy{r,k};
                DinvKyuAinvKuyDinvy = DinvKyuAinvKuyDinvy + model.KuyDinv{r,k}'*model.AinvKuyDinvy{r};
            end
            Q{k} = model.Dinv{k}*(model.D{k} - model.m{k}*model.m{k}' + Q{k})*model.Dinv{k};
            if strcmp(model.approx, 'fitc'),
                Q{k} = sparseDiag(diag(Q{k}));
            end
            dLdKyy{k} = -0.5*Q{k};
            if ~strcmp(model.kernType,'gg')
                dLdmu{k} = model.Dinv{k}*model.m{k} - DinvKyuAinvKuyDinvy;
            end
        end
        dLdKuy = cell(model.nlf,model.nout);
        for r =1:model.nlf,
            for k= 1:model.nout,
                dLdKuy{r,k} = model.KuuinvKuy{r,k}*Q{k}...
                    - CKuy{r,k}*model.Dinv{k} + model.AinvKuyDinvy{r}*model.m{k}'*model.Dinv{k};
            end
        end
        dLdKuu = cell(model.nlf,1);
        for r =1:model.nlf,
            KuuinvKuyQKyuKuuinv = zeros(model.k);
            dLdKuu{r} = zeros(model.k);
            for k=1: model.nout,
                KuuinvKuyQKyuKuuinv =  KuuinvKuyQKyuKuuinv + model.KuuinvKuy{r,k}*Q{k}*model.KuuinvKuy{r,k}';
            end
            dLdKuu{r} = 0.5*((model.Kuuinv{r} - C{r,r}) - KuuinvKuyQKyuKuuinv);
        end
        if nargout>4
            dLdbeta = zeros(1,model.nout);
            for k =1:model.nout,
                dLdbeta(k) = 0.5*model.beta(k)^(-2)*trace(Q{k});
            end
        end
end