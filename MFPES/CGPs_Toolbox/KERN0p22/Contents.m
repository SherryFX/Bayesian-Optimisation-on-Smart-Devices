% KERN toolbox
% Version 0.22		04-Mar-2009
% Copyright (c) 2009, Neil D. Lawrence
% 
, Neil D. Lawrence
% ARDKERNCOMPUTE Compute the ARD kernel given the parameters and X.
% ARDKERNDIAGCOMPUTE Compute diagonal of ARD kernel.
% ARDKERNDIAGGRADIENT Compute the gradient of the ARD kernel's diagonal wrt parameters.
% ARDKERNGRADIENT Gradient of ARD kernel's parameters.
% ARDKERNGRADX Gradient of ARD kernel with respect to a point x.
% BIASKERNGRADIENT Gradient of BIAS kernel's parameters.
% CMPNDKERNGRADIENT Gradient of CMPND kernel's parameters.
% CMPNDKERNPARAMINIT CMPND kernel parameter initialisation.
% GAUSSIANKERNCOMPUTE Compute the Gaussian kernel given the parameters and X.
% CMPNDKERNSETINDEX Set the indices in the compound kernel.
% EXPKERNCOMPUTE Compute the EXP kernel given the parameters and X.
% EXPKERNDIAGCOMPUTE Compute diagonal of EXP kernel.
% EXPKERNDIAGGRADX Gradient of EXP kernel's diagonal with respect to X.
% EXPKERNDISPLAY Display parameters of the EXP kernel.
% EXPKERNGRADIENT Gradient of EXP kernel's parameters.
% EXPKERNPARAMINIT EXP kernel parameter initialisation.
% FILEKERNDIAGCOMPUTE Compute diagonal of FILE kernel.
% FILEKERNGRADIENT Gradient of FILE kernel's parameters.
% FILEKERNPARAMINIT FILE kernel parameter initialisation.
% FILEKERNREAD Read kernel values from file or cache.
% GIBBSKERNCOMPUTE Compute the GIBBS kernel given the parameters and X.
% GIBBSKERNDIAGCOMPUTE Compute diagonal of GIBBS kernel.
% GIBBSKERNDIAGGRADIENT Compute the gradient of the GIBBS kernel's diagonal wrt parameters.
% GIBBSKERNDIAGGRADX Gradient of GIBBS kernel's diagonal with respect to X.
% GIBBSKERNDISPLAY Display parameters of the GIBBS kernel.
% GIBBSKERNEXPANDPARAM Create kernel structure from GIBBS kernel's parameters.
% GIBBSKERNEXTRACTPARAM Extract parameters from the GIBBS kernel structure.
% GIBBSKERNPARAMINIT GIBBS kernel parameter initialisation.
% GIBBSKERNSETLENGTHSCALEFUNC Set the length scale function of the GIBBS kernel.
% GIBBSPERIODICKERNCOMPUTE Compute the GIBBSPERIODIC kernel given the parameters and X.
% GIBBSPERIODICKERNDIAGCOMPUTE Compute diagonal of GIBBSPERIODIC kernel.
% GIBBSPERIODICKERNDIAGGRADX Gradient of GIBBSPERIODIC kernel's diagonal with respect to X.
% GIBBSPERIODICKERNDISPLAY Display parameters of the GIBBSPERIODIC kernel.
% ARDKERNDIAGGRADX Gradient of ARD kernel's diagonal with respect to X.
% ARDKERNDISPLAY Display parameters of the ARD kernel.
% ARDKERNEXPANDPARAM Create kernel structure from ARD kernel's parameters.
% GIBBSPERIODICKERNEXPANDPARAM Create kernel structure from GIBBSPERIODIC kernel's parameters.
% BIASKERNDIAGCOMPUTE Compute diagonal of BIAS kernel.
% BIASKERNDIAGGRADIENT Compute the gradient of the BIAS kernel's diagonal wrt parameters.
% BIASKERNDIAGGRADX Gradient of BIAS kernel's diagonal with respect to X.
% BIASKERNGRADX Gradient of BIAS kernel with respect to input locations.
% BIASKERNPARAMINIT BIAS kernel parameter initialisation.
% KERNCOMPUTE Compute the kernel given the parameters and X.
% CMPNDKERNCOMPUTE Compute the CMPND kernel given the parameters and X.
% KERNCREATE Initialise a kernel structure.
% KERNDIAGCOMPUTE Compute the kernel given the parameters and X.
% KERNDIAGGRADIENT Compute the gradient of the kernel's parameters for the diagonal.
% KERNDIAGGRADX Compute the gradient of the  kernel wrt X.
% KERNDISPLAY Display the parameters of the kernel.
% CMPNDKERNDIAGCOMPUTE Compute diagonal of CMPND kernel.
% CMPNDKERNDIAGGRADIENT Compute the gradient of the CMPND kernel's diagonal wrt parameters.
% CMPNDKERNDIAGGRADX Gradient of CMPND kernel's diagonal with respect to X.
% CMPNDKERNDISPLAY Display parameters of the CMPND kernel.
% KERNGRADIENT Compute the gradient wrt the kernel's parameters.
% CMPNDKERNEXPANDPARAM Create kernel structure from CMPND kernel's parameters.
% CMPNDKERNEXTRACTPARAM Extract parameters from the CMPND kernel structure.
% KERNPRIORLOGPROB Compute penalty terms associated with kernel priors.
% CMPNDKERNGRADX Gradient of CMPND kernel with respect to a point x.
% COMPUTEKERNEL Compute the kernel given the parameters and X.
% EXPKERNEXPANDPARAM Create kernel structure from EXP kernel's parameters.
% EXPKERNEXTRACTPARAM Extract parameters from the EXP kernel structure.
% KERNSETINDEX Set the indices on a compound kernel.
% KERNSETWHITE Helper function to set the white noise in a kernel if it exists.
% EXPKERNGRADX Gradient of EXP kernel with respect to a point x.
% FILEKERNCOMPUTE Compute the FILE kernel given the parameters and X.
% LINARDKERNDIAGCOMPUTE Compute diagonal of LINARD kernel.
% KERNGRADX Compute the gradient of the kernel wrt X.
% FILEKERNDISPLAY Display parameters of the FILE kernel.
% FILEKERNEXPANDPARAM Create kernel structure from FILE kernel's parameters.
% LINARDKERNEXPANDPARAM Create kernel structure from LINARD kernel's parameters.
% FILEKERNEXTRACTPARAM Extract parameters from the FILE kernel structure.
% FILEKERNGRADX Gradient of FILE kernel with respect to a point x.
% GIBBSKERNGRADIENT Gradient of GIBBS kernel's parameters.
% GIBBSKERNGRADX Gradient of GIBBS kernel with respect to input locations.
% GIBBSPERIODICKERNDIAGGRADIENT Compute the gradient of the GIBBSPERIODIC kernel's diagonal wrt parameters.
% GIBBSPERIODICKERNEXTRACTPARAM Extract parameters from the GIBBSPERIODIC kernel structure.
% LINARDKERNGRADX Gradient of LINARD kernel with respect to input locations.
% GIBBSPERIODICKERNGRADIENT Gradient of GIBBSPERIODIC kernel's parameters.
% GIBBSPERIODICKERNGRADX Gradient of GIBBSPERIODIC kernel with respect to a point x.
% GIBBSPERIODICKERNPARAMINIT GIBBSPERIODIC kernel parameter initialisation.
% KERNEXPANDPARAM Expand parameters to form a kernel structure.
% KERNEXTRACTPARAM Extract parameters from kernel structure.
% KERNFACTORS Extract factors associated with transformed optimisation space.
% KERNGETVARIANCE Get the signal associated with a the kernel.
% KERNPARAMINIT Kernel parameter initialisation.
% KERNPCA performs KPCA.
% KERNPRIORGRADIENT Compute gradient terms associated with kernel priors.
% MATERN32KERNDIAGGRADIENT Compute the gradient of the MATERN32 kernel's diagonal wrt parameters.
% MATERN32KERNDIAGGRADX Gradient of MATERN32 kernel's diagonal with respect to X.
% KERNREADFROMFID Load from an FID written by the C++ implementation.
% KERNREADPARAMSFROMFID Read the kernel parameters from C++ file FID.
% KERNTEST Run some tests on the specified kernel.
% KERNTOOLBOXES Load in the relevant toolboxes for kern.
% MATERN32KERNPARAMINIT MATERN32 kernel parameter initialisation.
% MATERN52KERNDIAGGRADX Gradient of MATERN52 kernel's diagonal with respect to X.
% LINARDKERNCOMPUTE Compute the LINARD kernel given the parameters and X.
% LINARDKERNDIAGGRADX Gradient of LINARD kernel's diagonal with respect to X.
% LINARDKERNDISPLAY Display parameters of the LINARD kernel.
% LINARDKERNEXTRACTPARAM Extract parameters from the LINARD kernel structure.
% MATERN52KERNEXPANDPARAM Create kernel structure from MATERN52 kernel's parameters.
% LINARDKERNGRADIENT Gradient of LINARD kernel's parameters.
% LINARDKERNPARAMINIT LINARD kernel parameter initialisation.
% LINKERNCOMPUTE Compute the LIN kernel given the parameters and X.
% LINKERNDIAGCOMPUTE Compute diagonal of LIN kernel.
% MLPARDKERNCOMPUTE Compute the MLPARD kernel given the parameters and X.
% LINKERNDIAGGRADX Gradient of LIN kernel's diagonal with respect to X.
% LINKERNDISPLAY Display parameters of the LIN kernel.
% LINKERNEXPANDPARAM Create kernel structure from LIN kernel's parameters.
% LINKERNEXTRACTPARAM Extract parameters from the LIN kernel structure.
% LINKERNGRADIENT Gradient of LIN kernel's parameters.
% LINKERNGRADX Gradient of LIN kernel with respect to input locations.
% LINKERNPARAMINIT LIN kernel parameter initialisation.
% MATERN32KERNCOMPUTE Compute the MATERN32 kernel given the parameters and X.
% MLPARDKERNGRADX Gradient of MLPARD kernel with respect to input locations.
% MATERN32KERNDIAGCOMPUTE Compute diagonal of MATERN32 kernel.
% MATERN32KERNDISPLAY Display parameters of the MATERN32 kernel.
% MATERN32KERNEXPANDPARAM Create kernel structure from MATERN32 kernel's parameters.
% MATERN32KERNEXTRACTPARAM Extract parameters from the MATERN32 kernel structure.
% MATERN32KERNGRADIENT Gradient of MATERN32 kernel's parameters.
% MLPKERNEXPANDPARAM Create kernel structure from MLP kernel's parameters.
% MATERN32KERNGRADX Gradient of MATERN32 kernel with respect to input locations.
% MATERN52KERNCOMPUTE Compute the MATERN52 kernel given the parameters and X.
% MATERN52KERNDIAGCOMPUTE Compute diagonal of MATERN52 kernel.
% MATERN52KERNDIAGGRADIENT Compute the gradient of the MATERN52 kernel's diagonal wrt parameters.
% MATERN52KERNDISPLAY Display parameters of the MATERN52 kernel.
% MATERN52KERNEXTRACTPARAM Extract parameters from the MATERN52 kernel structure.
% MATERN52KERNGRADIENT Gradient of MATERN52 kernel's parameters.
% MULTIKERNDIAGGRADIENT Compute the gradient of the MULTI kernel's diagonal wrt parameters.
% MATERN52KERNGRADX Gradient of MATERN52 kernel with respect to input locations.
% MATERN52KERNPARAMINIT MATERN52 kernel parameter initialisation.
% MLPARDKERNDIAGCOMPUTE Compute diagonal of MLPARD kernel.
% MULTIKERNGRADIENTBLOCK
% MLPARDKERNDIAGGRADX Gradient of MLPARD kernel's diagonal with respect to X.
% MLPARDKERNDISPLAY Display parameters of the MLPARD kernel.
% POLYARDKERNCOMPUTE Compute the POLYARD kernel given the parameters and X.
% MLPARDKERNEXPANDPARAM Create kernel structure from MLPARD kernel's parameters.
% MLPARDKERNEXTRACTPARAM Extract parameters from the MLPARD kernel structure.
% MLPARDKERNGRADIENT Gradient of MLPARD kernel's parameters.
% MLPARDKERNPARAMINIT MLPARD kernel parameter initialisation.
% POLYARDKERNDISPLAY Display parameters of the POLYARD kernel.
% MLPKERNGRADX Gradient of MLP kernel with respect to input locations.
% MLPKERNCOMPUTE Compute the MLP kernel given the parameters and X.
% MLPKERNDIAGCOMPUTE Compute diagonal of MLP kernel.
% MLPKERNDIAGGRADX Gradient of MLP kernel's diagonal with respect to X.
% MLPKERNDISPLAY Display parameters of the MLP kernel.
% POLYARDKERNPARAMINIT POLYARD kernel parameter initialisation.
% MLPKERNEXTRACTPARAM Extract parameters from the MLP kernel structure.
% MLPKERNGRADIENT Gradient of MLP kernel's parameters.
% POLYKERNEXPANDPARAM Create kernel structure from POLY kernel's parameters.
% MLPKERNPARAMINIT MLP kernel parameter initialisation.
% RBFWHITEKERNGRADX Gradient of RBF-WHITE kernel with respect to a point t.
% MULTIKERNCOMPUTEBLOCK
% POLYKERNPARAMINIT POLY kernel parameter initialisation.
% RBFWHITEKERNGRADIENT Gradient of RBF-WHITE kernel's parameters.
% MULTIKERNDIAGGRADX Gradient of MULTI kernel's diagonal with respect to X.
% MULTIKERNDISPLAY Display parameters of the MULTI kernel.
% MULTIKERNEXPANDPARAM Create kernel structure from MULTI kernel's parameters.
% MULTIKERNEXTRACTPARAM Extract parameters from the MULTI kernel structure.
% RATQUADKERNDIAGCOMPUTE Compute diagonal of RATQUAD kernel.
% OUKERNDIAGGRADX Gradient of OU kernel's diagonal with respect to t (see
% MULTIKERNGRADX Gradient of MULTI kernel with respect to a point x.
% MULTIKERNPARAMINIT MULTI kernel parameter initialisation.
% RATQUADKERNGRADIENT Gradient of RATQUAD kernel's parameters.
% MULTIKERNTEST Run some tests on the multiple output block kernel.
% RBFARDKERNCOMPUTE Compute the RBFARD kernel given the parameters and X.
% POLYARDKERNDIAGCOMPUTE Compute diagonal of POLYARD kernel.
% POLYARDKERNDIAGGRADX Gradient of POLYARD kernel's diagonal with respect to X.
% RBFARDKERNDISPLAY Display parameters of the RBFARD kernel.
% POLYARDKERNEXTRACTPARAM Extract parameters from the POLYARD kernel structure.
% POLYARDKERNGRADIENT Gradient of POLYARD kernel's parameters.
% POLYARDKERNGRADX Gradient of POLYARD kernel with respect to input locations.
% POLYKERNCOMPUTE Compute the POLY kernel given the parameters and X.
% RBFKERNCOMPUTE Compute the RBF kernel given the parameters and X.
% POLYKERNDIAGCOMPUTE Compute diagonal of POLY kernel.
% POLYKERNDIAGGRADX Gradient of POLY kernel's diagonal with respect to X.
% RBFKERNDISPLAY Display parameters of the RBF kernel.
% POLYKERNDISPLAY Display parameters of the POLY kernel.
% POLYKERNEXTRACTPARAM Extract parameters from the POLY kernel structure.
% POLYKERNGRADIENT Gradient of POLY kernel's parameters.
% POLYKERNGRADX Gradient of POLY kernel with respect to input locations.
% PSKERNELGRADIENT Gradient on likelihood approximation for point set IVM.
% PSKERNELOBJECTIVE Likelihood approximation for point set IVM.
% RATQUADKERNCOMPUTE Compute the RATQUAD kernel given the parameters and X.
% RATQUADKERNDIAGGRADIENT Compute the gradient of the RATQUAD kernel's diagonal wrt parameters.
% RATQUADKERNDIAGGRADX Gradient of RATQUAD kernel's diagonal with respect to X.
% RATQUADKERNDISPLAY Display parameters of the RATQUAD kernel.
% RATQUADKERNEXPANDPARAM Create kernel structure from RATQUAD kernel's parameters.
% RBFPERIODICKERNEXTRACTPARAM Extract parameters from the RBFPERIODIC kernel structure.
% RATQUADKERNEXTRACTPARAM Extract parameters from the RATQUAD kernel structure.
% RATQUADKERNGRADX Gradient of RATQUAD kernel with respect to input locations.
% RATQUADKERNPARAMINIT RATQUAD kernel parameter initialisation.
% RBFARDKERNDIAGCOMPUTE Compute diagonal of RBFARD kernel.
% RBFARDKERNDIAGGRADIENT Compute the gradient of the RBFARD kernel's diagonal wrt parameters.
% RBFARDKERNDIAGGRADX Gradient of RBFARD kernel's diagonal with respect to X.
% RBFARDKERNEXPANDPARAM Create kernel structure from RBFARD kernel's parameters.
% RBFARDKERNEXTRACTPARAM Extract parameters from the RBFARD kernel structure.
% SIMKERNDIAGGRADX Gradient of SIM kernel's diagonal with respect to X.
% RBFARDKERNGRADIENT Gradient of RBFARD kernel's parameters.
% RBFARDKERNGRADX Gradient of RBFARD kernel with respect to input locations.
% RBFARDKERNPARAMINIT RBFARD kernel parameter initialisation.
% SIMKERNGRADIENT Gradient of SIM kernel's parameters.
% RBFKERNDIAGCOMPUTE Compute diagonal of RBF kernel.
% RBFKERNDIAGGRADIENT Compute the gradient of the RBF kernel's diagonal wrt parameters.
% RBFKERNDIAGGRADX Gradient of RBF kernel's diagonal with respect to X.
% RBFKERNEXPANDPARAM Create kernel structure from RBF kernel's parameters.
% RBFKERNEXTRACTPARAM Extract parameters from the RBF kernel structure.
% RBFKERNGRADIENT Gradient of RBF kernel's parameters.
% SIMXRBFKERNGRADIENT Compute gradient between the SIM and RBF kernels.
% RBFKERNGRADX Gradient of RBF kernel with respect to input locations.
% RBFKERNPARAMINIT RBF kernel parameter initialisation.
% RBFPERIODICKERNCOMPUTE Compute the RBFPERIODIC kernel given the parameters and X.
% SQEXPKERNDIAGGRADX Gradient of SQEXP kernel's diagonal with respect to X.
% SQEXPKERNDISPLAY Display parameters of the SQEXP kernel.
% SQEXPKERNEXPANDPARAM Create kernel structure from SQEXP kernel's parameters.
% SQEXPKERNEXTRACTPARAM Extract parameters from the SQEXP kernel structure.
% SQEXPKERNGRADIENT Gradient of SQEXP kernel's parameters.
% RBFPERIODICKERNDIAGCOMPUTE Compute diagonal of RBFPERIODIC kernel.
% RBFPERIODICKERNDIAGGRADIENT Compute the gradient of the RBFPERIODIC kernel's diagonal wrt parameters.
% RBFPERIODICKERNDIAGGRADX Gradient of RBFPERIODIC kernel's diagonal with respect to X.
% RBFPERIODICKERNDISPLAY Display parameters of the RBFPERIODIC kernel.
% SQEXPKERNGRADX Gradient of SQEXP kernel with respect to a point x.
% SQEXPKERNPARAMINIT SQEXP kernel parameter initialisation.
% RBFPERIODICKERNEXPANDPARAM Create kernel structure from RBFPERIODIC kernel's parameters.
% RBFPERIODICKERNGRADIENT Gradient of RBFPERIODIC kernel's parameters.
% RBFPERIODICKERNGRADX Gradient of RBFPERIODIC kernel with respect to a point x.
% RBFPERIODICKERNPARAMINIT RBFPERIODIC kernel parameter initialisation.
% SIMCOMPUTEH Helper function for comptuing part of the SIM kernel.
% SIMCOMPUTETEST Test the file simComputeH.
% SIMKERNCOMPUTE Compute the SIM kernel given the parameters and X.
% SIMKERNDIAGCOMPUTE Compute diagonal of SIM kernel.
% SIMKERNDIAGGRADIENT Compute the gradient of the SIM kernel's diagonal wrt parameters.
% SIMKERNDISPLAY Display parameters of the SIM kernel.
% TENSORKERNGRADX Gradient of TENSOR kernel with respect to a point x.
% SIMKERNEXPANDPARAM Create kernel structure from SIM kernel's parameters.
% SIMKERNEXTRACTPARAM Extract parameters from the SIM kernel structure.
% SIMKERNGRADX Gradient of SIM kernel with respect to a point x.
% SIMKERNPARAMINIT SIM kernel parameter initialisation.
% SIMXRBFKERNCOMPUTE Compute a cross kernel between the SIM and RBF kernels.
% SIMXSIMKERNCOMPUTE Compute a cross kernel between two SIM kernels.
% SIMXSIMKERNGRADIENT Compute a cross gradient between two SIM kernels.
% WHITEFIXEDKERNCOMPUTE Compute the WHITEFIXED kernel given the parameters and X.
% WHITEFIXEDKERNDIAGCOMPUTE Compute diagonal of WHITEFIXED kernel.
% WHITEFIXEDKERNDIAGGRADIENT Compute the gradient of the WHITEFIXED kernel's diagonal wrt parameters.
% WHITEFIXEDKERNDIAGGRADX Gradient of WHITEFIXED kernel's diagonal with respect to X.
% WHITEFIXEDKERNDISPLAY Display parameters of the WHITEFIXED kernel.
% WHITEFIXEDKERNEXPANDPARAM Create kernel structure from WHITEFIXED kernel's parameters.
% WHITEFIXEDKERNEXTRACTPARAM Extract parameters from the WHITEFIXED kernel structure.
% SQEXPKERNCOMPUTE Compute the SQEXP kernel given the parameters and X.
% SQEXPKERNDIAGCOMPUTE Compute diagonal of SQEXP kernel.
% SQEXPKERNDIAGGRADIENT Compute the gradient of the SQEXP kernel's diagonal wrt parameters.
% TENSORKERNCOMPUTE Compute the TENSOR kernel given the parameters and X.
% TENSORKERNDIAGCOMPUTE Compute diagonal of TENSOR kernel.
% TENSORKERNDIAGGRADIENT Compute the gradient of the TENSOR kernel's diagonal wrt parameters.
% TENSORKERNDIAGGRADX Gradient of TENSOR kernel's diagonal with respect to X.
% TENSORKERNDISPLAY Display parameters of the TENSOR kernel.
% WHITEFIXEDKERNPARAMINIT WHITEFIXED kernel parameter initialisation.
% TENSORKERNEXPANDPARAM Create kernel structure from TENSOR kernel's parameters.
% TENSORKERNEXTRACTPARAM Extract parameters from the TENSOR kernel structure.
% TENSORKERNGRADIENT Gradient of TENSOR kernel's parameters.
% TENSORKERNPARAMINIT TENSOR kernel parameter initialisation.
% WHITEKERNGRADX Gradient of WHITE kernel with respect to input locations.
% TENSORKERNSETINDEX Set the indices in the tensor kernel.
% TENSORKERNSLASH Tensor kernel created by removing ith component.
% WHITEFIXEDKERNGRADIENT Gradient of WHITEFIXED kernel's parameters.
% WHITEFIXEDKERNGRADX Gradient of WHITEFIXED kernel with respect to a point x.
% WHITEKERNCOMPUTE Compute the WHITE kernel given the parameters and X.
% WHITEKERNDIAGCOMPUTE Compute diagonal of WHITE kernel.
% WHITEKERNDIAGGRADIENT Compute the gradient of the WHITE kernel's diagonal wrt parameters.
% WHITEKERNDIAGGRADX Gradient of WHITE kernel's diagonal with respect to X.
% WHITEKERNDISPLAY Display parameters of the WHITEkernel.
% WHITEKERNEXPANDPARAM Create kernel structure from WHITE kernel's parameters.
% WHITEKERNEXTRACTPARAM Extract parameters from the WHITE kernel structure.
% WHITEKERNGRADIENT Gradient of WHITE kernel's parameters.
% WHITEKERNPARAMINIT WHITE kernel parameter initialisation.
% WHITEXWHITEKERNCOMPUTE Compute a cross kernel between two WHITE kernels.
% WHITEXWHITEKERNGRADIENT Compute a cross gradient between two WHITE kernels.
% TRANSLATEKERNCOMPUTE Compute the TRANSLATE kernel given the parameters and X.
% TRANSLATEKERNDIAGCOMPUTE Compute diagonal of TRANSLATE kernel.
% TRANSLATEKERNDIAGGRADX Gradient of TRANSLATE kernel's diagonal with respect to X.
% TRANSLATEKERNDISPLAY Display parameters of the TRANSLATE kernel.
% TRANSLATEKERNEXPANDPARAM Create kernel structure from TRANSLATE kernel's parameters.
% GAUSSIANKERNDIAGCOMPUTE Compute diagonal of gaussian kernel.
% TRANSLATEKERNEXTRACTPARAM Extract parameters from the TRANSLATE kernel structure.
% TRANSLATEKERNGRADX Gradient of TRANSLATE kernel with respect to a point x.
% TRANSLATEKERNGRADIENT Gradient of TRANSLATE kernel's parameters.
% TRANSLATEKERNPARAMINIT TRANSLATE kernel parameter initialisation.
% COMPONENTKERNREADPARAMSFROMFID Read a component based kernel from a C++ file.
% DISIMXRBFKERNGRADIENT Compute gradient between the DISIM and RBF kernels.
% DISIMXSIMKERNCOMPUTE Compute a cross kernel between DISIM and SIM kernels.
% DISIMCOMPUTEHPRIME Helper function for comptuing part of the DISIM kernel.
% KERNCORRELATION Compute the correlation matrix kernel given the parameters and X.
% DISIMKERNCOMPUTE Compute the DISIM kernel given the parameters and X.
% DISIMKERNDIAGCOMPUTE Compute diagonal of DISIM kernel.
% DISIMKERNDIAGGRADX Gradient of DISIM kernel's diagonal with respect to X.
% DISIMKERNDIAGGRADIENT Compute the gradient of the DISIM kernel's diagonal wrt parameters.
% DISIMKERNDISPLAY Display parameters of the DISIM kernel.
% DISIMKERNEXPANDPARAM Create kernel structure from DISIM kernel's parameters.
% DISIMKERNEXTRACTPARAM Extract parameters from the DISIM kernel structure.
% RBFWHITEKERNEXTRACTPARAM Extract parameters from the RBF-WHITE kernel
% DISIMKERNGRADX Gradient of DISIM kernel with respect to a point x.
% DISIMKERNGRADIENT Gradient of DISIM kernel's parameters.
% DISIMKERNPARAMINIT DISIM kernel parameter initialisation.
% DISIMXDISIMKERNCOMPUTE Compute a cross kernel between two DISIM kernels.
% DISIMXRBFKERNCOMPUTE Compute a cross kernel between the DISIM and RBF kernels.
% DISIMCOMPUTEH Helper function for comptuing part of the DISIM kernel.
% DISIMXDISIMKERNGRADIENT Compute a cross gradient between two DISIM kernels.
% DISIMXSIMKERNGRADIENT Compute gradient between the DISIM and SIM kernels.
% COMPONENTKERNWRITEPARAMSTOFID Write a component based kernel to a stream.
% KERNWRITEPARAMSTOFID Write the kernel parameters to a stream.
% KERNWRITETOFID Load from an FID written by the C++ implementation.
% GAUSSIANKERNGRADX Gradient of gaussian kernel with respect to input locations.
% GAUSSIANKERNGRADIENT Gradient of gaussian kernel's parameters.
% GAUSSIANKERNDIAGGRADX Gradient of gaussian kernel's diagonal with respect to X.
% GAUSSIANKERNDIAGGRADIENT Compute the gradient of the gaussian kernel's diagonal wrt parameters.
% GAUSSIANKERNPARAMINIT Gaussian kernel parameter initialisation.
% GGKERNCOMPUTE Compute the GG kernel given the parameters and X.
% GGKERNDIAGCOMPUTE Compute diagonal of GG kernel.
% GGKERNEXPANDPARAM Create kernel structure from GG kernel's parameters.
% GGKERNEXTRACTPARAM Extract parameters from the GG kernel structure.
% GGKERNGRADIENT Gradient of GG kernel's parameters.
% GGKERNPARAMINIT GG kernel parameter initialisation.
% GGXGAUSSIANKERNCOMPUTE Compute a cross kernel between the GG and GAUSSIAN kernels.
% GGXGAUSSIANKERNGRADX Compute gradient between the GG and GAUSSIAN
% GGXGAUSSIANKERNGRADIENT Compute gradient between the GG and GAUSSIAN kernels.
% GAUSSIANKERNDISPLAY Display parameters of the GAUSSIAN kernel.
% GGKERNDISPLAY Display parameters of the GG kernel.
% GGXGGKERNCOMPUTE Compute a cross kernel between two GG kernels.
% LFMCOMPUTEH Helper function for computing part of the LFM kernel.
% LFMCOMPUTETEST Test the file lfmComputeH.
% LFMEXPANDPARAM Expand the given parameters into a LFM structure.
% LFMEXTRACTPARAM Extract the parameters of an LFM model.
% LFMGRADIENTH Gradient of the function h_i(z) with respect to some of the
% GAUSSIANKERNEXPANDPARAM Create kernel structure from gaussian kernel's parameters.
% LFMGRADIENTH31 Gradient of the function h_i(z) with respect to some of the
% GAUSSIANKERNEXTRACTPARAM Extract parameters from the gaussian kernel structure.
% GGXGGKERNGRADIENT Compute a cross gradient between two GG kernels.
% LFMGRADIENTSIGMAH Gradient of the function h_i(z) with respect \sigma.
% LFMGRADIENTUPSILON Gradient of the function \upsilon(z) with respect to
% LFMKERNCOMPUTE Compute the LFM kernel given the parameters and X.
% LFMKERNDIAGGRADX Gradient of LFM kernel's diagonal with respect to X.
% LFMKERNPARAMINIT LFM kernel parameter initialisation. The latent force
% LFMKERNDIAGGRADIENT Compute the gradient of the LFM kernel's diagonal wrt parameters.
% LFMKERNEXPANDPARAM Create kernel structure from LFM kernel's parameters.
% LFMKERNEXTRACTPARAM Extract parameters from the LFM kernel structure.
% LFMKERNGRADX Gradient of LFM kernel with respect to a point x.
% LFMKERNGRADIENT Gradient of LFM kernel's parameters.
% LFMLOGLIKEGRADIENTS Compute the gradients of the log likelihood of a LFM model.
% LFMLOGLIKELIHOOD Compute the log likelihood of a LFM model.
% LFMSAMPLE Sample from LFM kernel
% LFMUPDATEKERNELS Updates the kernel representations in the LFM structure.
% LFMKERNDISPLAY Display parameters of the LFM kernel.
% LFMOPTIONS Creates a set of default options for a LFM model.
% LFMTEST Test the gradients of the LFM model.
% LFMWHITECOMPUTEH Helper function for computing part of the LFM-WHITE
% LFMXLFMKERNCOMPUTE Compute a cross kernel between two LFM kernels.
% LFMXLFMKERNGRADIENT Compute a cross gradient between two LFM kernels.
% LFMXRBFKERNCOMPUTE Compute a cross kernel between the LFM and RBF kernels.
% LFMXRBFKERNGRADIENT Compute gradient between the LFM and RBF kernels.
% LFMCOMPUTEUPSILON Helper function for comptuing part of the LFM kernel.
% SPARSEKERNDISPLAY Display parameters of the SPARSE kernel.
% WHITEFIXEDXWHITEFIXEDKERNGRADIENT Compute a cross gradient between two WHITEFIXED kernels.
% LFMGRADIENTH32 Gradient of the function h_i(z) with respect to some of the
% WHITEFIXEDXWHITEFIXEDKERNCOMPUTE Compute a cross kernel between two WHITEFIXED kernels.
% LFMGRADIENTH41 Gradient of the function h_i(z) with respect to some of the
% LFMGRADIENTH42 Gradient of the function h_i(z) with respect to some of the
% LFMCOMPUTEH3 Helper function for computing part of the LFM kernel.
% LFMCREATE Create a LFM model.
% LFMGRADIENTSIGMAUPSILON Gradient of the function \upsilon(z) with respect
% LFMCOMPUTEH4 Helper function for computing part of the LFM kernel.
% LFMGRADIENTSIGMAH3 Gradient of the function h_i(z) with respect \sigma.
% LFMGRADIENTSIGMAH4 Gradient of the function h_i(z) with respect \sigma.
% KERNELCENTER Attempts to Center Kernel Matrix
% NONEKERNCOMPUTE Compute the NONE kernel given the parameters and X.
% GGWHITEXGAUSSIANWHITEKERNGRADX Compute gradient between the GG white and
% OUKERNDIAGCOMPUTE Compute diagonal of OU kernel (see ouKernCompute or
% OUKERNDISPLAY Display parameters of the OU kernel (see ouKernCompute or
% OUKERNEXTRACTPARAM Extract parameters from the OU kernel structure (see
% RBFWHITEKERNDISPLAY Display parameters of the RBF-WHITE kernel.
% NONEKERNDIAGCOMPUTE Compute diagonal of NONE kernel.
% NONEKERNDIAGGRADX Gradient of NONE kernel's diagonal with respect to X.
% NONEKERNDISPLAY Display parameters of the NONE kernel.
% NONEKERNEXPANDPARAM Create kernel structure from NONE kernel's parameters.
% NONEKERNEXTRACTPARAM Extract parameters from the NONE kernel structure.
% OUKERNCOMPUTE Compute the Ornstein-Uhlenbeck (OU) kernel arising from the
% WIENERKERNDIAGCOMPUTE Compute diagonal of WIENER kernel.
% ARDKERNEXTRACTPARAM Extract parameters from the ARD kernel structure.
% POLYARDKERNEXPANDPARAM Create kernel structure from POLYARD kernel's parameters.
% GGWHITEKERNDIAGCOMPUTE Compute diagonal of GG WHITE kernel.
% SIMWHITEXRBFWHITEKERNCOMPUTE Compute a cross kernel between a SIM-WHITE
% GAUSSIANWHITEKERNCOMPUTE Compute the covariance of the output samples 
% OUKERNEXPANDPARAM Create kernel structure from OU kernel's parameters
% RBFWHITEKERNDIAGGRADX Gradient of RBF-WHITE kernel's diagonal w.r.t. t.
% NONEKERNGRADX Gradient of NONE kernel with respect to a point x.
% NONEKERNGRADIENT Gradient of NONE kernel's parameters.
% NONEKERNPARAMINIT NONE kernel parameter initialisation.  
% RBFXNONEKERNCOMPUTE Compute a cross kernel between RBF and NONE kernels.
% GAUSSIANWHITEKERNPARAMINIT Gaussian white kernel parameter initialisation.
% WHITEXNONEKERNGRADIENT Compute a cross gradient between WHITE and DUMMY kernels.
% BIASKERNDISPLAY Display parameters of the BIASkernel.
% GAUSSIANWHITEKERNGRADIENT Gradient of gaussian white kernel's parameters.
% GGWHITEKERNDISPLAY Display parameters of the GG WHITE kernel.
% SIMWHITEXRBFWHITEKERNGRADIENT Compute a cross gradient between a SIM-WHITE
% RBFWHITEKERNCOMPUTE Compute the RBF-WHITE kernel given the parameters, t1
% OUKERNGRADIENT Gradient of OU kernel's parameters (see ouKernCompute or
% WHITEXNONEKERNCOMPUTE Compute a cross kernel between WHITE and NONE kernels.
% WHITEXRBFKERNGRADIENT Compute a cross gradient between WHITE and RBF kernels.
% WIENERKERNDIAGGRADX Gradient of WIENER kernel's diagonal with respect to X.
% MULTIKERNCACHEBLOCK
% LFMKERNDIAGCOMPUTE Compute diagonal of LFM kernel.
% MULTIKERNCOMPUTE Compute the MULTI kernel given the parameters and X.
% MULTIKERNFIXBLOCKS
% MULTIKERNDIAGCOMPUTE Compute diagonal of MULTI kernel.
% WIENERKERNDISPLAY Display parameters of the WIENER kernel.
% OUKERNPARAMINIT Ornstein-Uhlenbeck (OU) kernel parameter initialisation.
% RBFWHITEXRBFWHITEKERNCOMPUTE Compute a cross kernel between two RBF-WHITE
% RBFWHITEXWHITEKERNCOMPUTE Compute a cross kernel between the RBF-WHITE
% OUKERNGRADX Gradient of OU kernel with respect to a point x (see
% GAUSSIANWHITEKERNGRADX Gradient of gaussian white kernel with respect 
% WIENERKERNEXPANDPARAM Create kernel structure from WIENER kernel's parameters.
% RBFWHITEKERNPARAMINIT RBF-WHITE kernel parameter initialisation. The RBF-
% LFMWHITEKERNEXTRACTPARAM Extract parameters from the LFM-WHITE kernel
% LFMWHITEKERNGRADX Gradient of LFM-WHITE kernel with respect to a point t.
% LFMWHITEKERNGRADIENT Gradient of LFM-WHITE kernel's parameters.
% LFMWHITEKERNPARAMINIT LFM-WHITE kernel parameter initialisation.
% SIMWHITEXWHITEKERNGRADIENT Compute gradient between the SIM-WHITE and WHITE kernels.
% GAUSSIANWHITEKERNEXPANDPARAM Create kernel structure from gaussian white 
% GAUSSIANWHITEKERNEXTRACTPARAM Extract parameters from the gaussian white 
% GGWHITEKERNEXPANDPARAM Create kernel structure from GG white kernel's parameters.
% LFMWHITECOMPUTEGRADTHETAH1 computes a portion of the LFM-WHITE kernel's gradient w.r.t. theta.
% LFMWHITECOMPUTEGRADTHETAH2 computes a portion of the LFM-WHITE kernel's gradient w.r.t. theta.
% LFMWHITEKERNCOMPUTE Compute the LFM-WHITE kernel given the parameters, t1
% LFMWHITEKERNDIAGCOMPUTE Compute diagonal of LFM-WHITE kernel.
% LFMWHITEKERNDIAGGRADX Gradient of LFM-WHITE kernel's diagonal w.r.t. t.
% LFMWHITEKERNDISPLAY Display parameters of the LFM-WHITE kernel.
% LFMWHITEKERNEXPANDPARAM Create kernel structure from LFM-WHITE kernel's
% RBFWHITEXWHITEKERNGRADIENT Compute gradient between the RBF-WHITE and
% RBFWHITEKERNDIAGCOMPUTE Compute diagonal of RBF-WHITE kernel.
% SIMWHITEKERNEXPANDPARAM Create kernel structure from SIM-WHITE kernel's
% GAUSSIANWHITEKERNDISPLAY Display parameters of the GAUSSIAN white kernel.
% GGWHITEKERNEXTRACTPARAM Extract parameters from the GG WHITE kernel structure.
% RBFWHITEXRBFWHITEKERNGRADIENT Compute a cross gradient between two
% BIASKERNCOMPUTE Compute the BIAS kernel given the parameters and X.
% LFMWHITEXLFMWHITEKERNCOMPUTE Compute a cross kernel between two LFM-WHITE
% LFMWHITEXLFMWHITEKERNGRADIENT Compute a cross gradient between two
% LFMWHITEXWHITEKERNCOMPUTE Compute a cross kernel between the LFM-WHITE
% LFMWHITEXWHITEKERNGRADIENT Compute gradient between the LFM-WHITE and
% SIMWHITEXSIMWHITEKERNCOMPUTE Compute a cross kernel between two SIM-WHITE
% SIMWHITEXSIMWHITEKERNGRADIENT Compute a cross gradient between two
% SIMWHITEXWHITEKERNCOMPUTE Compute a cross kernel between the SIM-WHITE
% GAUSSIANWHITEKERNDIAGGRADIENT Compute the gradient of the gaussian white 
% GGWHITEKERNGRADIENT Gradient of GG WHITE kernel's parameters.
% RBFWHITEKERNEXPANDPARAM Create kernel structure from RBF-WHITE kernel's
% ARDKERNPARAMINIT ARD kernel parameter initialisation.
% WIENERKERNEXTRACTPARAM Extract parameters from the WIENER kernel structure.
% SIMWHITEKERNCOMPUTE Compute the SIM-WHITE kernel given the parameters, t1
% SIMWHITEKERNDIAGCOMPUTE Compute diagonal of SIM-WHITE kernel.
% SIMWHITEKERNDIAGGRADX Gradient of SIM-WHITE kernel's diagonal w.r.t. t.
% SIMWHITEKERNDISPLAY Display parameters of the SIM-WHITE kernel.
% SIMWHITEKERNEXTRACTPARAM Extract parameters from the SIM-WHITE kernel
% SIMWHITEKERNGRADX Gradient of SIM-WHITE kernel with respect to a point t.
% SIMWHITEKERNGRADIENT Gradient of SIM-WHITE kernel's parameters.
% SIMWHITEKERNPARAMINIT SIM-WHITE kernel parameter initialisation.
% GAUSSIANWHITEKERNDIAGCOMPUTE Compute diagonal of gaussian white kernel.
% GAUSSIANWHITEKERNDIAGGRADX Gradient of gaussian white kernel's diagonal with respect to X.
% GGWHITEKERNPARAMINIT GG WHITE kernel parameter initialisation.
% GGWHITEXGAUSSIANWHITEKERNCOMPUTE Compute a cross kernel between the GG white and GAUSSIAN white kernels.
% WIENERKERNGRADX Gradient of WIENER kernel with respect to a point x.
% WIENERKERNGRADIENT Gradient of WIENER kernel's parameters.
% GGWHITEXGAUSSIANWHITEKERNGRADIENT Compute gradient between the GG white 
% GGWHITEXGGWHITEKERNCOMPUTE Compute a cross kernel between two GG white kernels.
% GGWHITEXGGWHITEKERNGRADIENT Compute a cross gradient between two GG WHITE kernels.
% GGWHITEKERNCOMPUTE Compute the GG white kernel given the parameters and X.
% BIASKERNEXPANDPARAM Create kernel structure from BIAS kernel's parameters.
% WIENERKERNCOMPUTE Compute the WIENER kernel given the parameters and X.
% WIENERKERNPARAMINIT WIENER kernel parameter initialisation.
% MULTIKERNGRADIENT Gradient of MULTI kernel's parameters.
% MULTIKERNGRADIENTBLOCKX
% BIASKERNEXTRACTPARAM Extract parameters from the BIAS kernel structure.
