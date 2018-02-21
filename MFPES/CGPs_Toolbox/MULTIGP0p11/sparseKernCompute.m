function model = sparseKernCompute(model)

% SPARSEKERNCOMPUTE Computes the kernels for the sparse approximation in the convolution process framework.
%
%	Description:
%
%	MODEL = SPARSEKERNCOMPUTE(MODEL) computes the kernels for the sparse
%	approximation in the convolution process framework. This  version is
%	more computational effcient, because for the sparse approximations
%	we don't need to evaluate any cross covariances in the ouputs. In a
%	set up with many outputs, this should be a waste of resources if we
%	use the calssical way of computing in the kerntoolbox. On the other
%	hand, we can decide how to store the covariances of the outputs: as
%	a vector, corresponding to the diagonal of the covariances of the
%	outputs for the fitc or as a full covariance, corresponding to the
%	pitc.
%	 Returns:
%	  MODEL - the modified model structure with the kernels updated.
%	 Arguments:
%	  MODEL - the model structure


%	Copyright (c) 2008 Mauricio Alvarez
% 	sparseKernCompute.m SVN version 384
% 	last update 2009-06-04T19:57:30.000000Z

% Compute the Kuu and Kyu parts
for r = 1:model.nlf,
  model.Kuu{r,1} = zeros(model.k);
  for c = 1: length(model.kern.comp)
    model.Kuu{r,1} = model.Kuu{r,1} + real(multiKernComputeBlock(model.kern.comp{c},  model.X{r}, r, r));
  end
  for i =1:model.nout,
    model.Kyu{i,r} = real(multiKernComputeBlock(model.kern.comp{r},  model.X{i+model.nlf},...
                                                model.X{r}, i+model.nlf, r));
  end
end
% Compute the Kyy part
for j =1:model.nout,
  switch model.approx
   case {'dtc','fitc'}
    model.Kyy{j,1} = zeros(size(model.X{model.nlf + j},1),1);
   case 'pitc'
    model.Kyy{j,1} = zeros(size(model.X{model.nlf + j},1));
  end
  for c = 1: length(model.kern.comp)
    switch model.approx
     case {'dtc','fitc'}
      model.Kyy{j,1} = model.Kyy{j,1} + real(kernDiagCompute(model.kern.comp{c}.comp{j+model.nlf}, ...
                                                        model.X{j+model.nlf}));
     case 'pitc'
      model.Kyy{j,1} = model.Kyy{j,1} + real(multiKernComputeBlock(model.kern.comp{c}, ...
                                                        model.X{j+model.nlf}, j+model.nlf, j+model.nlf));
    end
  end
end


