function kern = kernParamInit(kern)

% KERNPARAMINIT Kernel parameter initialisation.
%
%	Description:
%
%	KERN = KERNPARAMINIT(KERN) initialises the parameters of a kernel.
%	 Returns:
%	  KERN - the kernel structure with the parameters initialised.
%	 Arguments:
%	  KERN - the kernel structure for which the parameters will be
%	   initialised.
%
%	See also
%	KERNCREATE
% 	kernParamInit.m CVS version 1.5
% 	kernParamInit.m SVN version 1
% 	last update 2009-03-04T16:40:07.370950Z

fhandle = str2func([kern.type 'KernParamInit']);
% By default don't transform kernel parameters.
kern.transforms = [];
kern = fhandle(kern);
