function [params, names] = lfmMeanExtractParam(meanFunction)

% LFMMEANEXTRACTPARAM Extract parameters from the LFM MEAN function structure.
%
%	Description:
%
%	PARAM = LFMMEANEXTRACTPARAM(MEANFUNCTION) Extract parameters from
%	the mean funtion structure of the lfm model into a vector of
%	parameters for optimisation.
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%
%	[PARAM, NAMES] = LFMMEANEXTRACTPARAM(MEANFUNCTION) Extract
%	parameters and their names from mean funtion structure of the lfm
%	model
%	 Returns:
%	  PARAM - vector of parameters extracted from the kernel.
%	  NAMES - cell array of strings containing parameter names.
%	 Arguments:
%	  MEANFUNCTION - the mean function structure containing the
%	   parameters to be extracted.
%	lfmkernExtractParam
%	
%
%	See also
%	% SEEALSO  LFMMEANCREATE, LFMMEANEXPANDPARAM, LFMKERNCREATE, 


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	lfmMeanExtractParam.m SVN version 289
% 	last update 2009-03-04T20:54:21.000000Z

params = [meanFunction.basal' meanFunction.spring'];
if nargout > 1
    names = cell(1, 2*meanFunction.nParams/2);
    for i=1:meanFunction.nParams/2        
        names{i} = ['lfm ' num2str(i) ' basal'];
    end    
    for i=meanFunction.nParams/2+1:2*meanFunction.nParams/2        
        names{i} = ['lfm ' num2str(i-meanFunction.nParams/2) ' spring'];
    end    
end


