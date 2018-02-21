function kern = kernReadParamsFromFID(kern, FID)

% KERNREADPARAMSFROMFID Read the kernel parameters from C++ file FID.
%
%	Description:
%
%	KERN = KERNREADPARAMSFROMFID(KERN, FID) reads kernel parameters from
%	a file written by C++.
%	 Returns:
%	  KERN - the kernel with the parameters added.
%	 Arguments:
%	  KERN - the kernel to put the parameters in.
%	  FID - the stream from which parameters are read.
%	
%
%	See also
%	KERNREADFROMFID, MODELREADFROMFID


%	Copyright (c) 2005, 2006, 2008 Neil D. Lawrence
% 	kernReadParamsFromFID.m CVS version 1.4
% 	kernReadParamsFromFID.m SVN version 187
% 	last update 2009-03-04T16:40:07.595000Z

if strcmp(kern.type, 'cmpnd') || strcmp(kern.type, 'tensor')
  kern = componentKernReadParamsFromFID(kern, FID);
else
  
  kern.inputDimension = readIntFromFID(FID, 'inputDim');
  numParams = readIntFromFID(FID, 'numParams');
  if strcmp(kern.type, 'poly') | strcmp(kern.type, 'polyard')
    kern.degree = readIntFromFID(FID, 'degree');
  end
  
  if strcmp(kern.type, 'white') 
    kern.variance = readIntFromFID(FID, 'variance');
  end
  
  params = modelReadFromFID(FID);
  fhandle = str2func([kern.type 'KernExpandParam']);
  kern = fhandle(kern, params);
  
  numPriors = readIntFromFID(FID, 'numPriors');
  for j=1:numPriors
    ind = readIntFromFID(FID, 'priorIndex');
    prior = priorReadFromFID(FID);
    prior.index = ind+1;
    kern.priors(j) = prior;
  end
end

