function  model = multigpCreate(q, d, X, y, options)

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

if iscell(X)
    if size(X{end}, 2) ~= q
        error(['Input matrix X does not have dimension ' num2str(q)]);
    end
else
    if size(X, 2) ~= q
        error(['Input matrix X does not have dimension ' num2str(q)]);
    end
end
if iscell(y)
    % ensure it is a row vector of cells.
    y = y(:)';
    if size(y, 2) ~= d
        error(['Target cell array Y does not have dimension ' num2str(d)]);
    end
    for i = 1:size(y, 2)
        if(size(y{i}, 2)>1)
            error('Each element of the cell array should be a column vector.')
        end
    end
else
    if size(y, 2)~=d
        error(['Target matrix Y does not have dimension ' num2str(d)]);
    end
end


model.type = 'multigp';
model.q = q;
model.M = options.M;

% Short hand for the kernel type
model.kernType = options.kernType;

% Number of latent functions
model.nlf = options.nlf;
if isfield(options, 'typeLf') && ~isempty(options.typeLf)
   model.typeLf = options.typeLf; 
end



% Number of output functions
model.d = d;

switch options.approx
    case 'ftc'
        % model.nout = d - options.nlf;
        model.nout = d;
    case {'dtc','fitc','pitc'}
        model.nout = d;
end

model.approx = options.approx;

% Set up default scale and bias for outputs
if isfield(options, 'scale') && ~isempty(options.scale)
    model.scale = options.scale;
else
    model.scale = ones(1, model.d);
end
if isfield(options, 'bias') && ~isempty(options.bias)
    model.bias = options.bias;
else
    model.bias = zeros(1, model.d);
end

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
        for i = 1: options.nlf,
            posX = zeros(options.numActive, q);
            switch options.initialInducingPositionMethod
                case 'espaced'
                    for j = 1:q,
                        med = (max(X{1}(:,j)) - min(X{1}(:,j)))/2;
                        posX(:,j) = linspace(min(X{1}(:,j)), max(X{1}(:,j)), options.numActive)';
                    end
                case 'espacedInRange'
                    for j = 1:q,
                        posX(:,j) = linspace(min(X{1}(:,j)), max(X{1}(:,j)), options.numActive)';
                    end
                case 'randomData'
                    index = randperm(size(X{1},1));
                    posX = X{1}(index(1:options.numActive),:);
                case 'randomComplete'
                    posX = randn(options.numActive, q);
                case 'fixIndices'
                    posX = X{1}(options.fixInices,:);
                case 'kmeans'
                    posX = kmeanlbg(X{1},options.numActive);
                case 'random'
                    if(q ~= 2)
                        error('This is not valid initialization q for the input variables');
                    end
                    l = 20;
                    for j = 1:q,
                        w = (max(X{1}(:,j)) - min(X{1}(:,j)))/l;
                        if j==q
                            a = repmat(min(X{1}(:,j)):w:max(X{1}(:,j)), l+1, 1);
                            tmp(:,j) = reshape(a', (l+1)*(l+1), 1);
                        
                        else
                            tmp(:,j) = reshape(repmat(min(X{1}(:,j)):w:max(X{1}(:,j)), l+1, 1), (l+1)*(l+1), 1);
                        end
                    end
                    index = randperm(l*l);
                    index(1:options.numActive);
                    posX = tmp(index(1:options.numActive), :);
                case 'fixed'
                    posX = options.posX;
                otherwise
                    error('This is not valid initialization method for the input variables');
            end
            model.X{i,1} = posX;
        end
        model.y = [];
        for i = 1:length(y)
            model.y = [model.y; y{i}];
            model.X{i + options.nlf,1} = X{i};
        end
        model.N = size(model.y,1);
        X = model.X;
        if size(options.beta,2) == model.nout
            model.beta = options.beta;
        else
            model.beta = options.beta*ones(1,model.nout);
        end
        model.betaTransform =  optimiDefaultConstraint('positive');
    otherwise
        error('Unknown model approximation')
end

model.includeInd = options.includeInd;	%independent kernel???
model.tieIndices = options.tieOptions.tieIndices;   %???
model.includeNoise = options.includeNoise;  % 1-include noise w(x)


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

model.kern = kernCreate(X, {'cmpnd', kernType{:}}); %cmpnd - sum of the individual kernels (f_q(x)+w_q(x))

if isfield(options, 'optimiser') && ~isempty(options.optimiser)
    model.optimiser = options.optimiser;    
end

% NEIL: Learning of scales hasn't been included, although it should be.
model.learnScales = options.learnScales;
model.scaleTransform = optimiDefaultConstraint('positive');

switch model.approx
    case {'dtc','fitc','pitc'}
        model = spmultigpCreate( model, options);   %%%%????
end

model.nParams = 0;

% Extract top level parameters from kernels.
model = multigpUpdateTopLevelParams(model); %%useless in our multi-output gp models

% Set up a mean function if one is given.
if isfield(options, 'meanFunction') && ~isempty(options.meanFunction)
    if isstruct(options.meanFunction)
        model.meanFunction = options.meanFunction;
    else
        if ~isempty(options.meanFunction)
            model.meanFunction = meanCreate(q, model.nout, X, y, options.meanFunctionOptions);
        end
    end
    model.nParams = model.nParams + model.meanFunction.nParams;
end

% Tie options according to the particular kernel employed

%%% Yehong: tieInd - groups of parameters of a model to be seen as one parameter during optimisation of the model 
%%% Yehong: e.g. sigma2_u/precision_u in gaussian and gg kernel

switch model.kernType
    case 'gg'
        if isfield(options, 'typeLf') && ~isempty(options.typeLf)
            cont = 0;
            for i = 1:options.typeLf(1)
                for j = 1:model.q
                    cont = cont + 1;
                    tieInd{cont} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                        ' .* inverse width latent \(' num2str(j) ',' num2str(j) '\)']);
                end
                cont = cont + 1;
                tieInd{cont} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                    ' .* variance latent']);
            end
            for i = 1+options.typeLf(1):options.typeLf(1)+options.typeLf(2)
                cont = cont + 1;
                tieInd{cont} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                    ' .* variance']);
            end
            for i = 1:model.nout-model.nlf
                for j = 1:model.q,
                    tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. ' num2str(i)...
                        ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);
                end
                % tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. gg ' num2str(i)  ' variance output']);
                tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. gg ' num2str(i)  ' mean']);
            end
        else
            cont = 0;
            for i = 1:options.nlf
                for j = 1:model.q
                    cont = cont + 1;
                    tieInd{cont} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                        ' .* inverse width latent \(' num2str(j) ',' num2str(j) '\)']);
                end
                cont = cont + 1;
                tieInd{cont} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                    ' .* variance latent']);
            end
            if model.nlf == 1
                tieInd{end+1} = paramNameRegularExpressionLookup(model, '. gg . mean');
            else
                for i = 1:model.nout-model.nlf
                    for j = 1:model.q,
                        tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. gg ' num2str(i)...
                            ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);
                    end
                    %tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. gg ' num2str(i)  ' variance output']);
                    % MAURICIO: If we consider the translation, it should
                    % have a different value for each dimension
                    tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. gg ' num2str(i)  ' mean']);
                end
            end
%             save tmp tieInd
        end
    case 'lfm'
        for i = 1:options.nlf
            tieInd{i} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                ' .* inverse width']);
        end
        for i = 1:model.nout
            tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. lfm ' num2str(i)  ' spring']);
            tieInd{end+1} = paramNameRegularExpressionLookup(model, ['multi ' ...
                '[0-9]+ lfm ' num2str(i)  ' damper']);
        end
    case 'lfmwhite'
        for i = 1:options.nlf
            tieInd{i} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                ' .* variance']);
        end
        for i = 1:model.nout
            %             tieInd{end+1} = paramNameRegularExpressionLookup(model, ['multi ' ...
            %                 '[0-9]+ lfm ' num2str(i)  ' spring']);
            tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. lfmwhite ' num2str(i)  ' spring']);
            tieInd{end+1} = paramNameRegularExpressionLookup(model, ['multi ' ...
                '[0-9]+ lfmwhite ' num2str(i)  ' damper']);
        end
    case {'sim'}
        if isfield(options, 'typeLf') && ~isempty(options.typeLf)
            for i = 1:options.typeLf(1)
                tieInd{i} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                    ' .* inverse width']);
            end
            for i = 1+options.typeLf(1):sum(options.typeLf)
                tieInd{end+1} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                    ' .* variance']);
            end
            if strcmp(options.tieOptions.selectMethod, 'typeLf')
                % Tying separately the decays for SIM and SIM-WHITE kernels
                % (i.e. for each output there is a separate decay for the
                % SIM kernels and for the SIM-WHITE kernels)
                for i = 1:model.nout
                    tieInd{end+1} = paramNameRegularExpressionLookup(model, ...
                        ['sim ' num2str(i)  ' decay']);
                    tieInd{end+1} = paramNameRegularExpressionLookup(model, ...
                        ['simwhite ' num2str(i)  ' decay']);
                end
            else
                for i = 1:model.nout
                    tieInd{end+1} = paramNameRegularExpressionLookup(model, ['.* ' num2str(i)  ' decay']);
                end
            end
        else
            for i = 1:options.nlf
                tieInd{i} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                    ' .* inverse width']);
            end
            for i = 1:model.nout
                tieInd{end+1} = paramNameRegularExpressionLookup(model, ['.* ' num2str(i)  ' decay']);
            end
        end
    case 'simwhite'
        for i = 1:options.nlf
            tieInd{i} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                ' .* variance']);
        end
        for i = 1:model.nout
            tieInd{end+1} = paramNameRegularExpressionLookup(model, ['.* ' num2str(i)  ' decay']);
        end
    case 'ggwhite'
        cont = 0;
        for i = 1:options.nlf
            cont = cont + 1;
            tieInd{cont} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                ' .* variance']);
        end
        if strcmp(options.tieOptions.selectMethod,'free')
            if model.nlf > 1
                if strcmp(model.approx, 'dtc')
                    for i = 1:model.nlf,
                        for j = model.q
                            tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. gaussianwhite ' num2str(i)...
                                ' inverse width latent \(' num2str(j) ',' num2str(j) '\)']);
                        end
                    end
                end
                for i = 1:model.nout
                    for j = 1:model.q,
                        tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. ggwhite ' num2str(i)...
                            ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);
                    end
                end
            end
        else
            if strcmp(model.approx, 'dtc')
                for i=1:model.nlf
                    tieInd{end+1} = paramNameRegularExpressionLookup(model, ['multi ' num2str(i) ...
                        ' gaussianwhite .* inverse width latent .*']);
                end
            end
            for i = 1:model.nout
                tieInd{end+1} = paramNameRegularExpressionLookup(model, ['. ggwhite ' num2str(i)...
                    ' inverse width output .*']);
            end
        end
    otherwise
        error('Kernel type not yet implemented')
end

model.nParams = model.nParams + model.kern.nParams;

switch model.approx
    case {'dtc','fitc','pitc'}
        model.nParams = model.nParams + model.nout; % Number of beta parameters
        if ~options.fixInducing
            model.nParams = model.nParams + model.k*model.q;
        end
end

% Fix parameters options according to the particular kernel employed

%%% Why they fix the latent variance and .gg.mean to log(1)?

switch model.kernType
    case 'gg'
        if isfield(options, 'typeLf') && ~isempty(options.typeLf)
            index = paramNameRegularExpressionLookup(model, 'multi .* variance latent');
            count = 0;
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(1, 'xtoa');
            end
            % Fix the means of the gg kernels.
            index = paramNameRegularExpressionLookup(model, 'multi .* mean');
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = 0;
            end
            if (model.nlf - options.typeLf(1)) > 1
                base = 0.5;
            else
                base = 1;
            end
            for i = 1+options.typeLf(1):model.nlf
                index = paramNameRegularExpressionLookup(model, ...
                    ['multi [' num2str(i) '] .* variance']);
                for k=1:length(index);
                    count = count + 1;
                    model.fix(count).index = index(k);
                    model.fix(count).value = expTransform(base*5^(i-(1+options.typeLf(1))), 'xtoa');
                end
            end
        else
            index = paramNameRegularExpressionLookup(model, 'multi .* variance latent');
            count = 0;
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(1, 'xtoa');
            end
            % Fix the masses of the lfm kernels.
            index = paramNameRegularExpressionLookup(model, 'multi .* mean');
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = 0;
            end
            
            if isfield(options, 'fixed')
                for k=1:length(options.fixed.index);
                    count = count + 1;
                    model.fix(count).index = options.fixed.index(k);
                    model.fix(count).value = options.fixed.value(k);
                end
                model.fixed = options.fixed;
            end
        end
    case 'lfm'
        % This code fixes masses and latent variances to 1.
        index = paramNameRegularExpressionLookup(model, ['multi ' ...
            '[0-9]+ rbf [0-9]+ variance']);
        count = 0;
        for k=1:length(index);
            count = count + 1;
            model.fix(count).index = index(k);
            model.fix(count).value = expTransform(1, 'xtoa');
        end
        % Fix the masses of the lfm kernels.
        index = paramNameRegularExpressionLookup(model, ['multi ' ...
            '[0-9]+ lfm [0-9]+ mass']);
        for k=1:length(index);
            count = count + 1;
            model.fix(count).index = index(k);
            model.fix(count).value = expTransform(1, 'xtoa');
        end
     case {'lfmwhite'}
        % This code fixes the latent variances to 1.
        index = paramNameRegularExpressionLookup(model, ...
            ['multi [1-' num2str(model.nlf) '] .* variance']);
        count = 0;
        for k=1:length(index);
            count = count + 1;
            model.fix(count).index = index(k);
            model.fix(count).value = expTransform(1, 'xtoa');
        end
        % Fix the masses of the lfm kernels.
        index = paramNameRegularExpressionLookup(model, ['multi ' ...
            '[0-9]+ lfmwhite [0-9]+ mass']);
        for k=1:length(index);
            count = count + 1;
            model.fix(count).index = index(k);
            model.fix(count).value = expTransform(1, 'xtoa');
        end    
    case {'sim'}
        if isfield(options, 'typeLf') && ~isempty(options.typeLf)
            % This code fixes latent variances to 1.
            index = paramNameRegularExpressionLookup(model, ['multi ' ...
                '[0-' num2str(options.typeLf(1)) ']+ rbf [0-9]+ variance']);
            count = 0;
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(1, 'xtoa');
            end
            % This code fixes the sim-white latent variances to (1/2)^i (i=0, 1, 2, ..., nlf-1).
            for i = 1+options.typeLf(1):model.nlf
                index = paramNameRegularExpressionLookup(model, ...
                    ['multi [' num2str(i) '] .* variance']);
                for k=1:length(index);
                    count = count + 1;
                    model.fix(count).index = index(k);
                    model.fix(count).value = expTransform(2^(-i+options.typeLf(1)+1), 'xtoa');
                end
            end
            % This code fixes the variance of the noise in the latent forces to 1e-9.
            for i = 1:model.nlf
                index = paramNameRegularExpressionLookup(model, ...
                    ['multi [' num2str(model.nlf+1) '] white [' num2str(i) '] .*']);
                for k=1:length(index);
                    count = count + 1;
                    model.fix(count).index = index(k);
                    model.fix(count).value = expTransform(1e-9, 'xtoa');
                end
            end
        else
            % This code fixes masses and latent variances to 1.
            if strcmp(model.kernType, 'sim'),
                index = paramNameRegularExpressionLookup(model, ['multi ' ...
                    '[0-' num2str(model.nlf) ']+ rbf [0-9]+ variance']);
            else
                index = paramNameRegularExpressionLookup(model, ['multi ' ...
                    '[0-' num2str(model.nlf) ']+ rbfnorm [0-9]+ variance']);
            end
            count = 0;
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(1, 'xtoa');
            end
            % This code fixes the variance of the noise in the latent forces to 1e-9.
%             for i = 1:model.nlf
%                 index = paramNameRegularExpressionLookup(model, ...
%                     ['multi [' num2str(model.nlf+1) '] white [' num2str(i) '] .*']);
%                 for k=1:length(index);
%                     count = count + 1;
%                     model.fix(count).index = index(k);
%                     model.fix(count).value = expTransform(1e-9, 'xtoa');
%                 end
%             end
        end
    case {'simwhite'}
        % This code fixes the latent variances to (1/2)^i (i=0, 1, 2, ..., nlf-1).
        count = 0;
        for i = 1:model.nlf
            index = paramNameRegularExpressionLookup(model, ...
                ['multi [' num2str(i) '] .* variance']);
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(2^(-i+1), 'xtoa');
            end
        end
        % This code fixes the variance of the noise in the latent forces to 1e-9.
        for i = 1:model.nlf
            index = paramNameRegularExpressionLookup(model, ...
                ['multi [' num2str(model.nlf+1) '] white [' num2str(i) '] .*']);
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(1e-9, 'xtoa');
            end
        end   
    case {'ggwhite'}
        count = 0;
        if model.nlf>1
            base = 0.5;
        else
            base = 1;
        end
        for i = 1:model.nlf
            index = paramNameRegularExpressionLookup(model, ...
                ['multi [' num2str(i) '] .* variance']);
            for k=1:length(index);
                count = count + 1;
                model.fix(count).index = index(k);
                model.fix(count).value = expTransform(base*5^(i-1), 'xtoa');
            end
        end
%         for i = 1:model.nlf
%             index = paramNameRegularExpressionLookup(model, ...
%                 ['multi [' num2str(model.nlf+1) '] white [' num2str(i) '] .*']);
%             for k=1:length(index);
%                 count = count + 1;
%                 model.fix(count).index = index(k);
%                 model.fix(count).value = expTransform(1e-9, 'xtoa');
%             end
%         end
end

model = modelTieParam(model, tieInd); %Get paramGroups
params = modelExtractParam(model);
model = modelExpandParam(model, params);
model.params = params;
%model.alpha = [];
end
