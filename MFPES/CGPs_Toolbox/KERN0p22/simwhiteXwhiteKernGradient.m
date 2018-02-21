function [g1, g2] = simwhiteXwhiteKernGradient(simKern, whiteKern, t1, varargin)

% SIMWHITEXWHITEKERNGRADIENT Compute gradient between the SIM-WHITE and WHITE kernels.
%
%	Description:
%
%	[G1, G2] = SIMWHITEXWHITEKERNGRADIENT(SIMKERN, WHITEKERN, T1,
%	COVGRAD) computes the gradient of an objective function with respect
%	to cross kernel terms between SIM-WHITE and WHITE kernels for the
%	multiple output kernel.
%	 Returns:
%	  G1 - gradient of objective function with respect to kernel
%	   parameters of SIM-WHITE kernel.
%	  G2 - gradient of objective function with respect to kernel
%	   parameters of WHITE kernel.
%	 Arguments:
%	  SIMKERN - the kernel structure associated with the SIM-WHITE
%	   kernel.
%	  WHITEKERN - the kernel structure associated with the WHITE kernel.
%	  T1 - inputs for which kernel is to be computed.
%	  COVGRAD - gradient of the objective function with respect to the
%	   elements of the cross kernel matrix.
%
%	[G1, G2] = SIMWHITEXWHITEKERNGRADIENT(SIMKERN, WHITEKERN, T1, T2,
%	COVGRAD) computes the gradient of an objective function with respect
%	to cross kernel terms between SIM-WHITE and WHITE kernels for the
%	multiple output kernel.
%	 Returns:
%	  G1 - gradient of objective function with respect to kernel
%	   parameters of SIM-WHITE kernel.
%	  G2 - gradient of objective function with respect to kernel
%	   parameters of WHITE kernel.
%	 Arguments:
%	  SIMKERN - the kernel structure associated with the SIM-WHITE
%	   kernel.
%	  WHITEKERN - the kernel structure associated with the WHITE kernel.
%	  T1 - row inputs for which kernel is to be computed.
%	  T2 - column inputs for which kernel is to be computed.
%	  COVGRAD - gradient of the objective function with respect to the
%	   elements of the cross kernel matrix.
%	whiteKernParamInit
%	
%
%	See also
%	MULTIKERNPARAMINIT, MULTIKERNCOMPUTE, SIMWHITEKERNPARAMINIT, 


%	Copyright (c) 2009 David Luengo
% 	simwhiteXwhiteKernGradient.m SVN version 285
% 	last update 2009-03-04T16:40:21.835768Z


if nargin < 5
    t2 = t1;
else
    t2 = varargin{1};
end
covGrad = varargin{end};

if size(t1, 2) > 1 | size(t2, 2) > 1
  error('Input can only have one column');
end
if simKern.variance ~= whiteKern.variance
  error('Kernels cannot be cross combined if they have different variances.')
end

g1 = zeros(1,3);
g2 = 0; % The only parameter of the WHITE kernel (its variance) is already
        % accounted for in g1

T1 = repmat(t1, 1, size(t2, 1));
T2 = repmat(t2.', size(t1, 1), 1);

K = simwhiteXwhiteKernCompute(simKern, whiteKern, t1, t2);

% Gradient w.r.t. D_q
g1(1) = sum(sum((T2-T1) .* K .* covGrad));

% Gradient w.r.t. sigma_r^2
g1(2) = sum(sum(K .* covGrad)) / simKern.variance;

% Gradient w.r.t. S_{qr}
g1(3) = sum(sum(K .* covGrad)) / simKern.sensitivity;
