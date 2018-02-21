function model = multigpUpdateKernels(model)

% MULTIGPUPDATEKERNELS Updates the kernel representations in the MULTIGP structure.
%
%	Description:
%	model = multigpUpdateKernels(model)
%% 	multigpUpdateKernels.m SVN version 382
% 	last update 2009-06-02T21:52:13.000000Z


switch model.approx
    case 'ftc'
        K = real(kernCompute(model.kern, model.X));
        % This is a hack to allow the inclusion of the latent structure
        % inside the kernel structure
        if sum(cellfun('length',model.X)) == model.N,
            base = 0;
        else
            base = model.nlf;
        end
        K = K(base+1:end, base+1:end);
        model.K = K;
        [model.invK, U, jitter] = pdinv(K);
%         if any(jitter>1e-4)
%             fprintf('Warning: UpdateKernels added jitter of %2.4f\n', jitter)
%         end
        model.alpha = multigpComputeAlpha(model);
        model.logDetK = logdet(model.K, U);
    case {'dtc','fitc','pitc'}
        model = spmultigpUpdateKernels(model);
end


