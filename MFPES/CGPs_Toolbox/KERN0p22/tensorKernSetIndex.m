function kern = tensorKernSetIndex(kern, component, indices)

% TENSORKERNSETINDEX Set the indices in the tensor kernel.
%
%	Description:
%	kern = tensorKernSetIndex(kern, component, indices)
%% 	tensorKernSetIndex.m CVS version 1.1
% 	tensorKernSetIndex.m SVN version 1
% 	last update 2009-03-04T16:40:23.455085Z

kern = cmpndKernSetIndex(kern, component, indices);