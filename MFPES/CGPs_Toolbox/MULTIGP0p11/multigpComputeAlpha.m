function alpha = multigpComputeAlpha(model, m)

% MULTIGPCOMPUTEALPHA Update the vector `alpha' for computing posterior mean quickly.
%
%	Description:
%
%	MODEL = MULTIGPCOMPUTEALPHA(MODEL, M) updates the vectors that are
%	known as `alpha' in the support vector machine, in other words
%	invK*y, where y is the target values.
%	 Returns:
%	  MODEL - the model with the updated alphas.
%	 Arguments:
%	  MODEL - the model for which the alphas are going to be updated.
%	  M - the values of m for which the updates will be made.
%	
%
%	See also
%	MULTIGPCREATE, MULTIGPUPDATEAD, MULTIGPUPDATEKERNELS


%	Copyright (c) 2008 Neil D. Lawrence
% 	multigpComputeAlpha.m SVN version 171
% 	last update 2009-01-07T17:41:47.000000Z

if nargin < 2
  m = model.m;
end

switch model.approx
 case 'ftc'
  alpha = model.invK*m;
 case {'dtc','fitc','pitc'}
  alpha = model.AinvKuyDinvy;          
 otherwise
  error('Alpha update not yet implemented for sparse kernels');
end