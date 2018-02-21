function model = multigpExpandParam(model, params)

% MULTIGPEXPANDPARAM Expand the given parameters into a MULTIGP structure.
%
%	Description:
%
%	MODEL = MULTIGPEXPANDPARAM(MODEL, PARAMS) expands the model
%	parameters from a structure containing the information about a
%	multi-output Gaussian process.
%	 Returns:
%	  MODEL - the model structure containing the information about the
%	   model updated with the new parameter vector.
%	 Arguments:
%	  MODEL - the model structure containing the information about the
%	   model.
%	  PARAMS - a vector of parameters from the model.
%	
%	
%
%	See also
%	MULTIGPCREATE, MODELEXPANDPARAM, MODELEXTRACTPARAM


%	Copyright (c) 2008 Mauricio A. Alvarez
%	Copyright (c) 2008 Neil D. Lawrence
% 	multigpExpandParam.m SVN version 384
% 	last update 2009-06-04T19:57:30.000000Z

paramPart = real(params);

if isfield(model, 'fix')
    for i = 1:length(model.fix)
       paramPart(model.fix(i).index) = model.fix(i).value;
    end
end

startVal = 1;
endVal = model.kern.nParams;
kernParams = paramPart(startVal:endVal);

if length(kernParams) ~= model.kern.nParams
    error('Kernel Parameter vector is incorrect length');
end

model.kern = kernExpandParam(model.kern, kernParams);

% Check if there is a mean function.`
if isfield(model, 'meanFunction') && ~isempty(model.meanFunction)
    startVal = endVal + 1;
    endVal = endVal + model.meanFunction.nParams;
    model.meanFunction = meanExpandParam(model.meanFunction, ...
        paramPart(startVal:endVal));
end

% Check if there is a beta parameter.
if isfield(model, 'beta') && ~isempty(model.beta)
    startVal = endVal + 1;
    endVal = endVal + model.nout;
    fhandle = str2func([model.betaTransform 'Transform']);
    model.beta = fhandle(paramPart(startVal:endVal), 'atox');
end

switch model.approx
    case {'dtc','fitc','pitc'}
        if ~model.fixInducing
            startVal = endVal + 1;
            endVal = endVal +  model.k*model.q;
            model = spmultigpExpandParam(model, paramPart(startVal:endVal)); % must do the contrary of spmultigpExtractParam
        end
    otherwise
        %
end
% Keep the values of parameters related with the mean at the top level.
model = multigpUpdateTopLevelParams(model);
model.m = multigpComputeM(model);
model = multigpUpdateKernels(model);

% Update the vector 'alpha' for computing posterior mean.
if isfield(model, 'alpha')
    model.alpha = multigpComputeAlpha(model);
end
end