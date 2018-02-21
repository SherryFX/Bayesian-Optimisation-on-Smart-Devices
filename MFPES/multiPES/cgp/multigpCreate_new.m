function  model = multigpCreate_new(model, X, y, options)

% MULTIGPCREATE creates a multi output GP based on a convolution.
%
%	Description:
%	Creates a multiple output Gaussian process using the idea of
%	the convolution process. The multigp model could be either FULL in the
%	sense that the full covariance of the model is employed or be SPARSE in
%	the sense that a low rank approximation is employed. The outputs of the
%	model are generated according to the convolution operation
%	
%	f_q(x) = \int_{-\infty}^{\infty}k_q(x-z)u(z)dz
%	
%	where f_q(x) is an output function, k_q(x) is a smoothing kernel and u(z)
%	is a latent function, which is considered as a Gaussian process. In
%	principle, more latent functions could be employed as well as the
%	addition of an independent process is desirable. In that case, the output
%	function is now given as
%	
%	y_q(x) = f_q(x) + w_q(x)
%	
%	where w_q(x) corresponds to the independent process.
%	
%
%	MODEL = MULTIGPCREATE(Q, D, Y, X, OPTIONS) returns a structure for
%	the multiple output Gaussian process model.
%	 Returns:
%	  MODEL - the structure for the multigp model
%	 Arguments:
%	  Q - input dimension size.
%	  D - output dimension size.
%	  Y - set of training observations
%	  X - set of training inputs
%	  OPTIONS - contains the options for the MULTIGP model, which
%	   includes if the model is approximated or full, the number of
%	   latent functions, the number of output functions.
%	


%	Copyright (c) 2008 Mauricio A. Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	multigpCreate.m SVN version 399
% 	last update 2009-06-10T20:54:00.000000Z

model.approx = options.approx;

q = model.q;
% Initialization of the model
switch model.approx
    case 'ftc'
        model.X = X;
        model.y = [];
        for i = 1:length(y)
            model.y = [model.y; y{i}];
        end
        model.N = size(model.y,1);
    case {'dtc','fitc','pitc'}
        model.y = [];
        for i = 1:length(y)
            model.y = [model.y; y{i}];
            model.X{i + options.nlf,1} = X{i};
        end
        model.N = size(model.y,1);
        X = model.X;
%         if size(options.beta,2) == model.nout
%             model.beta = options.beta;
%         else
%             model.beta = options.beta*ones(1,model.nout);
%         end
%         model.betaTransform =  optimiDefaultConstraint('positive');
    otherwise
        error('Unknown model approximation')
end

% This checks if there are different clases of latente forces
if isfield(options, 'typeLf') && ~isempty(options.typeLf)
%     if ~strcmp(options.approx,'dtc')
%        error('This options has only been implemented for dtc') 
%     end
    if options.nlf ~= sum(options.typeLf) 
        error('The number of latent functions per type is different to the total number of latent functions')
    end
    cont = 0;
    for i = 1:options.typeLf(1)
        cont = cont + 1;
        kernType{cont} = multigpKernComposer(options.kernType, model.d, model.nlf, model.approx, i);
    end    
    for i = 1:options.typeLf(2)
        cont = cont + 1;
        kernType{cont} = multigpKernComposer([options.kernType 'white'], model.d, model.nlf, model.approx, i+options.typeLf(1));
    end    
else
    for i = 1:options.nlf
        kernType{i} = multigpKernComposer(options.kernType, model.d, model.nlf, model.approx, i);
    end
end

% To include independent kernel
if model.includeInd
    kernType{end+1} = multigpKernComposer('rbf', model.d, model.nlf, model.approx);
end
% To include noise
if model.includeNoise
    kernType{end+1} = multigpKernComposer('white', model.d, model.nlf, model.approx);
end

model.kern = kernCreate(X, {'cmpnd', kernType{:}});

% Set up a mean function if one is given.
% if isfield(options, 'meanFunction') && ~isempty(options.meanFunction)
%     if isstruct(options.meanFunction)
%         model.meanFunction = options.meanFunction;
%     else
%         if ~isempty(options.meanFunction)
%             model.meanFunction = meanCreate(q, model.nout, X, y, options.meanFunctionOptions);
%         end
%     end
%     model.nParams = model.nParams + model.meanFunction.nParams;
% end

% % Extract top level parameters from kernels.
% model = multigpUpdateTopLevelParams(model)
% 
% params = modelExtractParam(model);

model = modelExpandParam(model, model.params);


end
