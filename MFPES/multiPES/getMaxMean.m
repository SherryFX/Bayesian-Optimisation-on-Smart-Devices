function [f_xstar, xstar] = getMaxMean(model, xmin, xmax, task, t, opts)

    M = model.M;
    
    mu_func{1} = @(x) getPosteriorMean(model, x', t);
    
    opts.dis_num = 20;
    opts.discrete = 1;
    if size(xmin, 2) > 2
        opts.discrete = 0;
    end
    [xstar, ~] = globalOptimizationNoGradient(mu_func, xmin', xmax', opts);
    xstar = xstar';
    
    task_type = task{M+1};
    xstar = transX(xstar, lower(task_type), true);
    f_xstar = getFuncValue_mobile(task, xstar, M, t);
end

function [ ret ] = getPosteriorMean(model, xtest, t)

    nlf = model.nlf;
    [mu, ~] = multigpPosteriorMeanVar(model, xtest);
    ret = mu{t+nlf};

end


