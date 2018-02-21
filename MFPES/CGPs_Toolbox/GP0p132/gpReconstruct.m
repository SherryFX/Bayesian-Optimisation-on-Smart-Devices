function model = gpReconstruct(kern, noise, gpInfo, X, y)

% GPRECONSTRUCT Reconstruct an GP form component parts.
%
%	Description:
%
%	MODEL = GPRECONSTRUCT(KERN, NOISE, GPINFO, X, Y) takes component
%	parts of an GP model and reconstructs the GP model. The component
%	parts are normally retrieved from a saved file.
%	 Returns:
%	  MODEL - an GP model structure that combines the component parts.
%	 Arguments:
%	  KERN - a kernel structure for the GP.
%	  NOISE - a noise structure for the GP (currently ignored).
%	  GPINFO - the active set and other information stored in a
%	   structure.
%	  X - the input training data for the GP.
%	  Y - the output target training data for the GP.
%	
%
%	See also
%	GPDECONSTRUCT, GPCREATE


%	Copyright (c) 2007, 2009 Neil D. Lawrence
% 	gpReconstruct.m SVN version 178
% 	last update 2009-01-08T13:48:55.000000Z

options = gpOptions(gpInfo.approx);
options.kern = kern;
switch gpInfo.approx
 case 'ftc'
 case {'dtc', 'dtcvar', 'fitc', 'pitc'}
  options.numActive = size(gpInfo.X_u, 1);
end
model = gpCreate(size(X, 2), size(y, 2), X, y, options);
model.scale = gpInfo.scale;
model.bias = gpInfo.bias;
model.m = gpComputeM(model);
model.learnScales = gpInfo.learnScales;
switch model.approx
 case 'ftc'
 case {'dtc', 'dtcvar', 'fitc', 'pitc'}
  model.beta = gpInfo.beta;
  model.fixInducing = gpInfo.fixInducing;
  if gpInfo.fixInducing
    model.inducingIndices = gpInfo.inducingIndices;
  else
    model.X_u = gpInfo.X_u;
  end
end

if gpInfo.d ~= size(y, 2)
  error('y does not have correct number of dimensions.')
end
if gpInfo.q ~= size(X, 2)
  error('X does not have correct number of dimensions.')
end
% FOrce update of everything.
params = gpExtractParam(model);
model = gpExpandParam(model, params);
