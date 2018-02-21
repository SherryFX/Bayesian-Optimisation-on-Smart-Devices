function meanFunction = simMeanCreate(q, d, options)

% SIMMEANCREATE returns a structure for the SIM mean function.
%
%	Description:
%
%	SIMMEANCREATE creates the mean function for a multi output GP model
%	based in the SIM kernel (first order differential equation) The
%	outputs of the model are generated according to
%	mean_q = B_q/D_q
%	
%	where mean_q is an output constant corresponding to the mean of the
%	output function q, B_q is basal transcription and D_q is the decay
%	constant.
%	RETURN model : the structure for the multigp model
%	ARG q : input dimension size.
%	ARG d : output dimension size.
%	ARG options : contains the options for the MEAN of the MULTIGP model.
%	
%	SEE ALSO: simKernParamInit, simKernCompute
%	


%	Copyright (c) 2008 Mauricio A. Alvarez and Neil D. Lawrence
% 	simMeanCreate.m SVN version 289
% 	last update 2009-03-04T20:54:27.000000Z

if q > 1
  error('SIM MEAN FUNCTION only valid for one-D input.')
end

meanFunction.type = 'sim';
meanFunction.basal  = ones(d,1);
meanFunction.decay = ones(d,1);
meanFunction.transforms.index = 1:2*d;
meanFunction.transforms.type = optimiDefaultConstraint('positive');
% Only the parameters of basal rates are counted. The springs are already
% counted in the kernel
meanFunction.nParams = 2*d; 