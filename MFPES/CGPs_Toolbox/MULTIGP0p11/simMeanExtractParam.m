function [params, names] = simMeanExtractParam(meanFunction)

% SIMMEANEXTRACTPARAM Extract parameters from the SIM MEAN FUNCTION structure.
%
%	Description:
%
%	PARAM = SIMMEANEXTRACTPARAM(MEANFUNCTION) Extract parameters from
%	the mean funtion structure of the sim model into a vector of
%	parameters for optimisation.
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%
%	[PARAM, NAMES] = SIMMEANEXTRACTPARAM(MEANFUNCTION) Extract
%	parameters and their names from mean funtion structure of the sim
%	model
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	  NAMES - cell array of strings containing parameter names.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%	simkernExtractParam
%	
%
%	See also
%	% SEEALSO  SIMMEANCREATE, SIMMEANEXPANDPARAM, SIMKERNCREATE, 


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	simMeanExtractParam.m SVN version 289
% 	last update 2009-03-04T20:54:27.000000Z

params = [meanFunction.basal' meanFunction.decay'];
if nargout > 1
    names = cell(1, 2*meanFunction.nParams/2);
    for i=1:meanFunction.nParams/2        
        names{i} = ['sim ' num2str(i) ' basal'];
    end    
    for i=meanFunction.nParams/2+1:2*meanFunction.nParams/2        
        names{i} = ['sim ' num2str(i-meanFunction.nParams/2) ' decay'];
    end    
end
