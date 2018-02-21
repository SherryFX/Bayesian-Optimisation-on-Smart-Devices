function model = spmultigpUpdateAD(model)

% SPMULTIGPUPDATEAD Update the representations of A and D associated with
%
%	Description:
%	the model.
%
%	MODEL = SPMULTIGPUPDATEAD(MODEL) updates the representations of A
%	and D in the model when called by spmultigpUpdateKernels.
%	 Returns:
%	  MODEL - the model with the A and D representations updated.
%	 Arguments:
%	  MODEL - the model for which the representations are being updated.
%	
%
%	See also
%	SPMULTIGPUPDATEKERNELS, SPMULTIGPEXPANDPARAM


%	Copyright (c)  Mauricio Alvarez 2008
% 	spmultigpUpdateAD.m SVN version 384
% 	last update 2009-06-04T19:57:30.000000Z


for r=1:model.nlf,
    [model.Kuuinv{r}, model.sqrtKuu{r}, jitter] = pdinv(model.Kuu{r});
    model.logDetKuu{r} = logdet(model.Kuu{r}, model.sqrtKuu{r});
end

for r =1: model.nlf,
    for k =1: model.nout,
        model.KuuinvKuy{r,k} = model.Kuuinv{r}*model.Kyu{k,r}';
    end
end

for k =1: model.nout,
    KyuKuuinvKuy = zeros(size(model.Kyy{k},1),size(model.Kyy{k},1));
    for r =1: model.nlf,
        KyuKuuinvKuy = KyuKuuinvKuy + model.Kyu{k,r}*model.KuuinvKuy{r,k};
    end
    switch model.approx
        case 'dtc'
            model.D{k} = sparseDiag(1/model.beta(k)*ones(size(model.X{k+model.nlf},1),1));
            model.Dinv{k} = sparseDiag(model.beta(k)*ones(size(model.X{k+model.nlf},1),1));
            model.logDetD{k} = -size(model.X{k+model.nlf},1)*log(model.beta(k));
            model.Ktilde{k} = model.Kyy{k} - diag(KyuKuuinvKuy);
        case 'fitc'
            model.D{k} = model.Kyy{k} - diag(KyuKuuinvKuy); % In fitc D is a diagonal matrix.
            if ~isempty(model.beta)
                model.D{k} = (model.D{k} + 1/model.beta(k));
            end
            model.Dinv{k} = sparseDiag(1./model.D{k});
            model.logDetD{k} = sum(log(model.D{k}));
            model.D{k} = sparseDiag(model.D{k});% This is to keep the flow of the gradients
        case 'pitc'
            model.D{k} = model.Kyy{k} - KyuKuuinvKuy; % In pitc D is a block-diagonal matrix
            if ~isempty(model.beta)
                model.D{k} = (model.D{k} + eye(size(model.D{k},1))/model.beta(k));
            end
            model.D{k} = checkKernelSymmetry(model.D{k});
            [model.Dinv{k}, model.sqrtD{k}, jitter] = pdinv(model.D{k});
%             if jitter>1e-4
%                warning('Big Jitter') 
%             end            
            model.logDetD{k} = logdet(model.D{k}, model.sqrtD{k});
        otherwise
            error('Unknown approximation type')    
    end
    
end

for k =1:model.nlf,
    for q =1:model.nout,
        switch model.approx
            case 'dtc'        
                model.KuyDinv{k,q} = model.beta(q)*model.Kyu{q,k}';                
            case {'fitc','pitc'}
                model.KuyDinv{k,q} = model.Kyu{q,k}'*model.Dinv{q};
        end
    end
end

for r =1:model.nlf,
    model.KuyDinvy{r,1} = zeros(model.k,1);
    for q =1:model.nout,
        model.KuyDinvy{r} = model.KuyDinvy{r} + model.KuyDinv{r,q}*model.m{q};
    end
end

for k =1:model.nlf,
    for r =1:model.nlf,
        KuyDinvKyu = zeros(model.k,model.k);
        for q =1:model.nout,
            KuyDinvKyu = KuyDinvKyu + model.KuyDinv{k,q}*model.Kyu{q,r};
        end
        if (k == r)
            model.A{k,r} = model.Kuu{k} + KuyDinvKyu;
        else
            model.A{k,r} = KuyDinvKyu;
        end
    end
end

A = cell2mat(model.A);

[Ainv, sqrtA, jitter]  = pdinv(A);
model.logDetA = logdet(A, sqrtA);

model.Ainv  = mat2cell(Ainv,model.k*ones(1,model.nlf), model.k*ones(1,model.nlf));
model.sqrtA = mat2cell(sqrtA,model.k*ones(1,model.nlf), model.k*ones(1,model.nlf));


for r = 1:model.nlf,
    model.AinvKuyDinvy{r,1} = zeros(model.k,1);
    for k = 1:model.nlf,
        model.AinvKuyDinvy{r} = model.AinvKuyDinvy{r} + model.Ainv{r,k}*model.KuyDinvy{k};
    end
end


