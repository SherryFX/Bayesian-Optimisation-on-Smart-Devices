function meanFunction = simwhiteMeanExpandParam(meanFunction, params)

% SIMWHITEMEANEXPANDPARAM Extract the parameters of the vector parameter
%
%	Description:
%	and put them back in the mean function structure for the SIM-WHITE model.
%	DESC returns a mean function SIM-WHITE structure filled with the
%	parameters in the given vector. This is used as a helper function to
%	enable parameters to be optimised in, for example, the NETLAB
%	optimisation functions.
%	ARG meanFunction : the meanFunction structure in which the parameters are
%	to be placed.
%	ARG param : vector of parameters which are to be placed in the
%	kernel structure.
%	RETURN meanFunction : mean function structure with the given parameters
%	in the relevant locations.
%	
%	
%	
%
%	See also
%	SIMWHITEMEANCREATE, SIMWHITEMEANEXTRACTPARAM, KERNEXPANDPARAM


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	simwhiteMeanExpandParam.m SVN version 277
% 	last update 2009-03-04T20:54:27.000000Z

meanFunction.basal  = params(1:meanFunction.nParams/2)';
meanFunction.decay  = params(meanFunction.nParams/2+1:meanFunction.nParams)';

