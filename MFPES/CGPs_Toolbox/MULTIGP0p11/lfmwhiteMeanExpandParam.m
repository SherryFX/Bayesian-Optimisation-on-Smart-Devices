function meanFunction = lfmwhiteMeanExpandParam(meanFunction, params)

% LFMWHITEMEANEXPANDPARAM Extract the parameters of the vector parameter
%
%	Description:
%	and put them back in the mean function structure for the LFM-WHITE model.
%
%	MEANFUNCTION = LFMWHITEMEANEXPANDPARAM(MEANFUNCTION, PARAM) returns
%	a mean function LFM-WHITE structure filled with the parameters in
%	the given vector. This is used as a helper function to enable
%	parameters to be optimised in, for example, the NETLAB optimisation
%	functions.
%	 Returns:
%	  MEANFUNCTION - mean function structure with the given parameters
%	   in the relevant locations.
%	 Arguments:
%	  MEANFUNCTION - the meanFunction structure in which the parameters
%	   are to be placed.
%	  PARAM - vector of parameters which are to be placed in the kernel
%	   structure.
%	
%	
%
%	See also
%	LFMWHITEMEANCREATE, LFMWHITEMEANEXTRACTPARAM, KERNEXPANDPARAM


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	lfmwhiteMeanExpandParam.m SVN version 289
% 	last update 2009-03-04T20:54:23.000000Z

meanFunction.basal  = params(1:meanFunction.nParams/2)';
meanFunction.spring = params(meanFunction.nParams/2+1:meanFunction.nParams)';
