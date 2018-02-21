function [model, X, Y] = initializeBO(model, method, task, xmin, xmax, givenX, givenY)
    
    M = model.M;
    nlf = model.nlf;
    q = model.q;
    X = cell(M, 1);
    Y = cell(M, 1);
%     noise = task{M+1};
    
    switch method       
        case 'fixed'
            for i=1:M
                X{i} = [xmin(1), xmin(2); xmin(1), xmax(2); xmax(1), xmin(2); xmax(1), xmax(2); (xmax-xmin)./2];
            end
            
        case 'random'
            data_size = [1, 1];
            scale = xmax-xmin;
            for i=1:M
                X{i} = rand(data_size(i), 2).*repmat(scale, data_size(i), 1) + repmat(xmin, data_size(i), 1);
            end

        case 'random5'
            data_size = [50, 50];
            scale = [xmax(1)-xmin(1), xmax(2)-xmin(2)];
            for i=1:M
                X{i} = rand(data_size(i), 2).*repmat(scale, data_size(i), 1) + repmat(xmin, data_size(i), 1);
            end
            
        case 'given'
            data_size = ones(1, M);
            scale = xmax-xmin;
            for i=1:M
                X{i} = givenX{i}.*repmat(scale, data_size(i), 1) + repmat(xmin, data_size(i), 1);
            end
            
        case 'lr'
            for i=1:M
                X{i} = givenX{i};
                Y{i} = givenY{i};
            end
            
        case 'cnn'
            for i=1:M
                X{i} = givenX{i};
                Y{i} = givenY{i};
            end
            
        otherwise
            error('Invalid initialization method.')
    end
    
    if ~strcmp(method, 'lr') && ~strcmp(method, 'cnn')
        for i=1:M
            Y{i} = getObsValue(task, X{i}, M, i);
        end
    end
    
    switch model.approx
        case 'ftc'
            Xtrain = cell(M+nlf, 1);
            ytrain = cell(M+nlf, 1);
            for j=1:nlf
               ytrain{j} = [];
               Xtrain{j} = zeros(1, q);  
            end
            s = nlf;
        case {'dtc','fitc','pitc'}
            Xtrain = cell(M, 1);
            ytrain = cell(M, 1);
            s = 0;
        otherwise
            error('Invalid approx method');
    end
    
    if ~isfield(model, 'ymean')
        model.ymean = zeros(M, 1);
    end
    
    for j=1:M
        Xtrain{j+s} = transX(X{j}, method);
        ytrain{j+s} = transY(Y{j}, model.ymean(j), method);
    end
    
    if model.train

        options = multigpOptions(model.approx);
        options.kernType = 'gg';
        options.optimiser = 'scg';
        options.nlf = model.nlf;
        options.q = model.q;
        options.d = model.M + options.nlf;
        options.M = model.M;
        options.ymean = model.ymean;
        if isfield(model, 'fixed')
            options.fixed = model.fixed;
        end
        
        model = multigpCreate(options.q, options.d, Xtrain, ytrain, options);
        params = modelExtractParam(model);
        for i =1:M,
            for j =1:model.q
                index = paramNameRegularExpressionLookup(model,['multi .* ' num2str(i) ...
                    ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);
                avgLengthScale = rand*(xmax(j)-xmin(j));
                params(index) = log(2) - 2*log(0.1*avgLengthScale);
%                 params(index) = rand+log(1000);
            end
        end
        model = modelExpandParam(model, params);
    %     % Change the inverse width of the latent functions
        params = modelExtractParam(model);
        for i=1:model.nlf
            for j =1:model.q
                index = paramNameRegularExpressionLookup(model,['multi ', num2str(i),' .* ', num2str(i) ...
                    ' inverse width latent \(' num2str(j) ',' num2str(j) '\)']);
        %         avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + 1}(:,j))), 1));
%                 params(index) = rand + log(10);% - 2*log(0.1*avgLengthScale);
                avgLengthScale = rand*(xmax(j)-xmin(j));
                params(index) = log(2) - 2*log(avgLengthScale);
            end
        end
        model = modelExpandParam(model, params);
        params = modelExtractParam(model);
        model.params = params;

        model.M = M;
        model.train = 0;
        model.options = options;
        model.xmin = xmin;
        model.xmax = xmax;
        model.ymean = options.ymean;
    else
        model = updateBO(model, Xtrain, ytrain);
    end
    
    