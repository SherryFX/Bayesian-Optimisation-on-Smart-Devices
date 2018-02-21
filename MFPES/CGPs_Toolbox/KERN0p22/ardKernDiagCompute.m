function k = ardKernDiagCompute(kern, x)

% ARDKERNDIAGCOMPUTE Compute diagonal of ARD kernel.
%
%	Description:
%
%	K = ARDKERNDIAGCOMPUTE(KERN, X) computes the diagonal of the kernel
%	matrix for the pre-built RBF and linear ARD kernel given a design
%	matrix of inputs.
%	 Returns:
%	  K - a vector containing the diagonal of the kernel matrix computed
%	   at the given points.
%	 Arguments:
%	  KERN - the kernel structure for which the matrix is computed.
%	  X - input data matrix in the form of a design matrix.
%	
%
%	See also
%	ARDKERNPARAMINIT, KERNDIAGCOMPUTE, KERNCREATE, ARDKERNCOMPUTE


%	Copyright (c) 2004 Neil D. Lawrence
% 	ardKernDiagCompute.m CVS version 1.3
% 	ardKernDiagCompute.m SVN version 1
% 	last update 2009-03-04T16:39:58.967870Z


scales = sparse(diag(sqrt(kern.inputScales)));
x = x*scales;

rbfPart = ones(size(x, 1), 1);
linearPart = sum(x.*x, 2)*kern.linearVariance;
k = rbfPart*(kern.rbfVariance + kern.whiteVariance) + kern.biasVariance +linearPart;
