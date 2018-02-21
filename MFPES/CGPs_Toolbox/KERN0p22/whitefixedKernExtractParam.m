function [params, names] = whitefixedKernExtractParam(kern)

% WHITEFIXEDKERNEXTRACTPARAM Extract parameters from the WHITEFIXED kernel structure.
%
%	Description:
%
%	PARAM = WHITEFIXEDKERNEXTRACTPARAM(KERN) Extract parameters from the
%	fixed parameter white noise kernel structure into a vector of
%	parameters for optimisation.
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel. If the
%	   field 'transforms' is not empty in the kernel matrix, the
%	   parameters will be transformed before optimisation (for example
%	   positive only parameters could be logged before being returned).
%	 Arguments:
%	  KERN - the kernel structure containing the parameters to be
%	   extracted.
%
%	[PARAM, NAMES] = WHITEFIXEDKERNEXTRACTPARAM(KERN) Extract parameters
%	and parameter names from the fixed parameter white noise kernel
%	structure.
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel. If the
%	   field 'transforms' is not empty in the kernel matrix, the
%	   parameters will be transformed before optimisation (for example
%	   positive only parameters could be logged before being returned).
%	  NAMES - cell array of strings containing parameter names.
%	 Arguments:
%	  KERN - the kernel structure containing the parameters to be
%	   extracted.
%	
%	
%
%	See also
%	% SEEALSO WHITEFIXEDKERNPARAMINIT, WHITEFIXEDKERNEXPANDPARAM, KERNEXTRACTPARAM, SCG, CONJGRAD


%	Copyright (c) 2006 Nathaniel J. King
% 	whitefixedKernExtractParam.m CVS version 1.6
% 	whitefixedKernExtractParam.m SVN version 1
% 	last update 2009-03-04T16:40:24.447432Z
params = [];
names = {};