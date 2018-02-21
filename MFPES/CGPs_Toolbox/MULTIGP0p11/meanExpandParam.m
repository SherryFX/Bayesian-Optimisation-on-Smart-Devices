function meanFunction = meanExpandParam(meanFunction, params)

% MEANEXPANDPARAM Extract the parameters of the vector parameter and put
%
%	Description:
%	them back in a mean function structure.
%	DESC returns a mean function structure filled with the
%	parameters in the given vector. This is used as a helper function to
%	enable parameters to be optimised in, for example, the NETLAB
%	optimisation functions.
%	ARG meanFunction : the meanFunction structure in which the parameters are to be
%	placed.
%	ARG param : vector of parameters which are to be placed in the
%	kernel structure.
%	RETURN meanFunction : mean function structure with the given parameters in the
%	relevant locations.
%	
%	
%
%	See also
%	MEANCREATE, MEANEXTRACTPARAM, MEANEXPANDPARAM


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	meanExpandParam.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

if isfield(meanFunction, 'paramGroups')
  params = params*meanFunction.paramGroups';
end

% Check if parameters are being optimised in a transformed space.
if ~isempty(meanFunction.transforms)
  for i = 1:length(meanFunction.transforms)
    index = meanFunction.transforms(i).index;
    fhandle = str2func([meanFunction.transforms(i).type 'Transform']);
    params(index) = fhandle(params(index), 'atox');
  end
end
fhandle = str2func([meanFunction.type 'MeanExpandParam']);
meanFunction = fhandle(meanFunction, params);


