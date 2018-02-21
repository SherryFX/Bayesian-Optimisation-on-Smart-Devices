function [params, names] =  meanExtractParam(meanFunction)

% MEANEXTRACTPARAM Extract parameters from a MEAN FUNCTION structure.
%
%	Description:
%
%	PARAM = MEANEXTRACTPARAM(MODEL) Extract parameters from a mean
%	funtion structure into a vector of parameters for optimisation.
%	 Returns:
%	  PARAM - vector of parameters extracted from the mean function.
%	 Arguments:
%	  MODEL - the mean function structure containing the parameters to
%	   be extracted.
%
%	[PARAM, NAMES] = MEANEXTRACTPARAM(MODEL) Extract parameters and
%	their names from a mean funtion structure
%	 Returns:
%	  PARAM - vector of parameters extracted from the mean function.
%	  NAMES - cell array of strings containing parameter names.
%	 Arguments:
%	  MODEL - the mean function structure containing the parameters to
%	   be extracted.
%	kernExtractParam
%	
%
%	See also
%	% SEEALSO  MEANCREATE, MEANEXPANDPARAM, KERNCREATE, 


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	meanExtractParam.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

fhandle = str2func([meanFunction.type 'MeanExtractParam']);

if nargout > 1
  [params, names] = fhandle(meanFunction);
else
  params = fhandle(meanFunction);
end

% Check if parameters are being optimised in a transformed space.
if ~isempty(meanFunction.transforms)
  for i = 1:length(meanFunction.transforms)
    index = meanFunction.transforms(i).index;
    fhandle = str2func([meanFunction.transforms(i).type 'Transform']);
    params(index) = fhandle(params(index), 'xtoa');
  end
end

params = params*meanFunction.paramGroups;
