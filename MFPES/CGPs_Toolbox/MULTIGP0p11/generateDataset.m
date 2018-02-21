function [ll, X, y] = generateDataset(kernName, inputDim, nout, nDataPoints)

% GENERATEDATASET Generates samples from a multigp model
%
%	Description:
%
%	[LL, X, Y] = GENERATEDATASET(KERNNAME, INPUTDIM, NOUT, NDATAPOINTS)
%	Generates data, sampling from a multigp model with specified kernel
%	 Returns:
%	  LL - likelihood given by the full GP
%	  X - input data sampled from a Gaussian distribution
%	  Y - output data generated
%	 Arguments:
%	  KERNNAME - name of the kernel for the multigp construction
%	  INPUTDIM - dimension of the input space
%	  NOUT - number of outputs to be generated
%	  NDATAPOINTS - number of data points per output


%	Copyright (c) 2009 Mauricio Alvarez
% 	generateDataset.m SVN version 399
% 	last update 2009-06-10T20:54:00.000000Z


inverseWidth = [10 5 5 100 30 200 400 20 1 40];
sensitivity =  [1  2  2.2 1.5 1  3   4   2  1    10];
noisePerOutput = 1e-2;
nlf = 1;
d = nlf + nout;
% Sample the inputs
X1 = gsamp(zeros(inputDim,1), eye(inputDim), nDataPoints);
kernType{1} = multigpKernComposer(kernName, d, nlf, 'ftc', 1);
kernType{2} = multigpKernComposer('white',  d, nlf, 'ftc', 1);
kern = kernCreate(X1,  {'cmpnd', kernType{:}});
kern.comp{1}.comp{1}.variance = 1;
for k = 1:nout,
    kern.comp{1}.comp{1+k}.precisionG = inverseWidth(k)*ones(inputDim,1);
    kern.comp{1}.comp{1+k}.variance = sensitivity(k);
    kern.comp{2}.comp{1+k}.variance = noisePerOutput;
end
K = kernCompute(kern, X1);
yu = gsamp(zeros(size(K,1),1), K, 1);
u = yu(1:size(X1,1));
y = yu(size(X1,1)+1:end);
Kout = K(1+size(X1,1):end,1+size(X1,1):end);
[invKout, U, jitter] = pdinv(Kout);
if any(jitter>1e-4)
    fprintf('Warning: Added jitter of %2.4f\n', jitter)
end
logDetKout = logdet(Kout, U);
dim = size(y, 2);
ll = -dim*log(2*pi) -logDetKout - y*invKout*y';
ll = ll*0.5;
U = reshape(u,size(X1,1),nlf);
Y = reshape(y,size(X1,1),nout);
X = cell(1, nout);
y = cell(1, nout);
for k =1:nout,
    X{k} = X1;
    y{k} = Y(:,k);
end
