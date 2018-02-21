function model = spmultigpUpdateKernels(model)

% SPMULTIGPUPDATEKERNELS
%
%	Description:
%
%	MODEL = SPMULTIGPUPDATEKERNELS(MODEL) Update the kernels that are
%	needed for the sparse multigp
%	 Returns:
%	  MODEL - the model structure with updated kernels.
%	 Arguments:
%	  MODEL - the model structure containing the model parameters


%	Copyright (c)  Mauricio Alvarez
% 	spmultigpUpdateKernels.m SVN version 267
% 	last update 2009-03-04T09:28:00.000000Z

switch model.approx
    case {'dtc','fitc', 'pitc'}      
        model = sparseKernCompute(model);    
    otherwise
        %
end

model = spmultigpUpdateAD(model);
