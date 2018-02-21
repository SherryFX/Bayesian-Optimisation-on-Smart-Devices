function [params, names] = simwhiteMeanExtractParam(meanFunction)

% SIMWHITEMEANEXTRACTPARAM Extract parameters from the SIM-WHITE mean function structure.
%
%	Description:
%
%	PARAM = SIMWHITEMEANEXTRACTPARAM(MEANFUNCTION) Extract parameters
%	from the mean funtion structure of the SIM-WHITE model into a vector
%	of parameters for optimisation.
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%	DESC Extract parameters and their names from mean funtion structure of
%	the SIM-WHITE model
%	ARG meanFunction : the mean function structure containing the parameters
%	to be extracted.
%	RETURN param : vector of parameters extracted from the kernel.
%	RETURN names : cell array of strings containing parameter names.
%	
%	simwhiteKernExtractParam
%	
%	
%
%	See also
%	% SEEALSO  SIMWHITEMEANCREATE, SIMWHITEMEANEXPANDPARAM, SIMWHITEKERNCREATE, 


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	simwhiteMeanExtractParam.m SVN version 289
% 	last update 2009-03-04T20:54:27.000000Z

params = [meanFunction.basal' meanFunction.decay'];
if nargout > 1
    names = cell(1, 2*meanFunction.nParams/2);
    for i=1:meanFunction.nParams/2        
        names{i} = ['simwhite ' num2str(i) ' basal'];
    end    
    for i=meanFunction.nParams/2+1:2*meanFunction.nParams/2        
        names{i} = ['simwhite ' num2str(i-meanFunction.nParams/2) ' decay'];
    end    
end
