
function [ modelnew ] = CGP_train(Xtrain, Ytrain, options, iters, xmin, xmax)

%     model = multigpCreate(options.q, options.d, Xtrain, Ytrain, options);
    
    fmin = Inf;
    for loop=1:10
        
        model = multigpCreate(options.q, options.d, Xtrain, Ytrain, options);
        M = size(Ytrain, 1) - model.nlf;

        params = modelExtractParam(model);
        for i =1:M,
            for j =1:model.q
                index = paramNameRegularExpressionLookup(model,['multi .* ' num2str(i) ...
                    ' inverse width output \(' num2str(j) ',' num2str(j) '\)']);

                if size(model.X{model.nlf + i}, 1) == 1
                    avgLengthScale = abs(rand)*(xmax(j)-xmin(j));
                else
                    avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf + i}(:,j)))));
                end
                params(index) = log(2) - 2*log(0.1*avgLengthScale) + log(abs(randn));
%                 params(index) = rand+log(1000);
            end
        end
        model = modelExpandParam(model, params);

        % Change the inverse width of the latent functions
        params = modelExtractParam(model);
        for i=1:model.nlf
            for j =1:model.q
                index = paramNameRegularExpressionLookup(model,['multi ', num2str(i),' .* ', num2str(i) ...
                    ' inverse width latent \(' num2str(j) ',' num2str(j) '\)']);

                if size(model.X{model.nlf+i}, 1) == 1
                    avgLengthScale = rand*(xmax(j)-xmin(j));
                else
                    avgLengthScale = sqrt(mean(abs(diff(model.X{model.nlf+i}(:,j)))));
                end
                params(index) = log(2) - 2*log(avgLengthScale) + log(abs(randn));
    %             params(index) = rand + log(10*rand);
            end
        end
        model = modelExpandParam(model, params);
        
        % Train the model 
        % init_time = cputime;
        display = 0;
        [model, f] = multigpOptimise(model, display, iters);
        % elapsed_time = cputime - init_time;
        disp(['Negative loglikelihood: ', num2str(f)]);
        if f < fmin
            modelnew = model;
            fmin = f;
        end
    end

    modelnew.train = 0;
    modelnew.options = options;
    modelnew.M = M;



