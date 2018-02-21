function [params, names] = lfmwhiteMeanExtractParam(meanFunction)

% LFMWHITEMEANEXTRACTPARAM Extract parameters from the LFM-WHITE mean function structure.
%
%	Description:
%
%	PARAM = LFMWHITEMEANEXTRACTPARAM(MEANFUNCTION) Extract parameters
%	from the mean funtion structure of the LFM-WHITE model into a vector
%	of parameters for optimisation.
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%
%	[PARAM, NAMES] = LFMWHITEMEANEXTRACTPARAM(MEANFUNCTION) Extract
%	parameters and their names from mean funtion structure of the
%	LFM-WHIE model
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	  NAMES - cell array of strings containing parameter names.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%	lfmwhiteKernExtractParam
%	
%	
%
%	See also
%	% SEEALSO  LFMWHITEMEANCREATE, LFMWHITEMEANEXPANDPARAM, LFMWHITEKERNCREATE, 


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	lfmwhiteMeanExtractParam.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

params = [meanFunction.basal' meanFunction.spring'];
if nargout > 1
    names = cell(1, 2*meanFunction.nParams/2);
    for i=1:meanFunction.nParams/2        
        names{i} = ['lfmwhite ' num2str(i) ' basal'];
    end    
    for i=meanFunction.nParams/2+1:2*meanFunction.nParams/2        
        names{i} = ['lfmwhite ' num2str(i-meanFunction.nParams/2) ' spring'];
    end    
end
