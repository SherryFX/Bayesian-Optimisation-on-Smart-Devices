function [gKernParam, gX_u] = sparseKernGradient(model,dLdKyy, dLdKuy, dLdKuu)

% SPARSEKERNGRADIENT Computes the gradients of the parameters for sparse multigp kernel.
%
%	Description:
%	
%
%	[GKERNPARAM, GX_U] = SPARSEKERNGRADIENT(MODEL, DLDKYY, DLDKUU,
%	DLDKUY) computes the gradients of the parameters for sparse multigp
%	kernel. When using more than one latent function, the partial
%	derivative is organized in a suitable way so that the kernGradient
%	routine can be used.
%	 Returns:
%	  GKERNPARAM - derivatives wrt to the parameters of the kernels of
%	   latent, output and independent functions
%	  GX_U - derivatives wrt to the inducing points of the latent
%	   functions
%	 Arguments:
%	  MODEL - the model for which the gradients are to be computed.
%	  DLDKYY - the gradient of the likelihood with respect to the block
%	   or diagonal terms.
%	  DLDKUU - the gradient of the likelihood with respect to the
%	   elements of K_uu.
%	  DLDKUY - the gradient of the likelihood with respect to the
%	   elements of K_uf.


%	Copyright (c) 2008 Mauricio A. Alvarez and Neil D. Lawrence
% 	sparseKernGradient.m SVN version 377
% 	last update 2009-06-02T21:52:13.000000Z

if nargout>1
    gX_u =  zeros(size(model.X_u));
end
gKernParam = zeros(1, size(model.kern.paramGroups, 1));
startVal3 = 1;
endVal3 = 0;
for c = 1:length(model.kern.comp)
    endVal3 = endVal3 + model.kern.comp{c}.nParams;
    gMulti = zeros(1, size(model.kern.comp{c}.paramGroups, 1));
    startVal = 1;
    endVal = 0;
    for i = 1:model.kern.comp{c}.numBlocks
        endVal = endVal + model.kern.comp{c}.comp{i}.nParams;
        if i<=model.nlf
            covPartial = dLdKuu{i,1};
            % In case the derivatives wrt to X are necessary
            if nargout>1 && i==c                
                gX = real(multiKernGradientBlockX(model.kern.comp{c}, model.X{c}, i, i));
                gXu = zeros(size(model.X{c}));
                for k = 1:size(model.X{c},1),
                    for j=1:size(model.X{c},2),
                        gXu(k,j) = dLdKuu{c}(k,:)*gX(:,j,k);
                    end
                end
                gX_u = gX_u + gXu;               
            end                        
        else
            covPartial = dLdKyy{i - model.nlf,1};
        end
        gMulti(1, startVal:endVal) = real(multiKernGradientBlock(model.kern.comp{c}, model.X{i}, ...
            covPartial, i, i));
        startVal2 = 1;
        endVal2 = 0;
        if i > model.nlf && c <= model.nlf
            endVal2 = endVal2 + model.kern.comp{c}.comp{c}.nParams;
            [g1, g2] = multiKernGradientBlock(model.kern.comp{c}, model.X{i}, ...
                model.X{c}, dLdKuy{c,i - model.nlf}', i, c);
            gMulti(1, startVal:endVal) = gMulti(1, startVal:endVal) + real(g1);
            gMulti(1, startVal2:endVal2) = gMulti(1, startVal2:endVal2) + real(g2);
            % In case the derivatives wrt to X are necessary
            if nargout>1
                gX = real(multiKernGradientBlockX(model.kern.comp{c}, model.X{i}, model.X{c}, i, c));
                gXu = zeros(size(model.X{c}));
                for k = 1:size(model.X{c},1),
                    for j=1:size(model.X{c},2),
                        gXu(k,j) = dLdKuy{c,i - model.nlf}(k,:)*gX(:,j,k);
                    end
                end
                gX_u = gX_u + gXu;
            end
        end
        startVal = endVal + 1;
    end
    gKernParam(1, startVal3:endVal3) = gMulti;
    startVal3 = endVal3 + 1;
end


