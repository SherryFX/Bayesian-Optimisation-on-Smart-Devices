% First step of EP approximation (independent of x)

% return: fi_xstar aftr eq. (5.16) 

function [ret, modelnew] = EPapproximation(xstar, model, max_iter, c)
    
    nSamples = size(xstar, 1);
	f_star = cell(nSamples, 1);
    
    % p(f_*|D_n)
    for i = 1 : nSamples
        [f_star{i}.m, f_star{i}.var] = multigpPosteriorSinglef(model, xstar(i, :));
    end
    M = model.M;
    nlf = model.nlf;
    start = 1;
    ymax = zeros(M, 1);
    sigma2_n = getNoise(model);
    for i=1:M
        nx = size(model.X{i+nlf}, 1); 
        y = model.y(start:start+nx-1);
        ymax(i) = max(y);
        start = start+nx;
    end
    
    M = model.M;
    ret.m = zeros(nSamples, M);
    ret.v = zeros(nSamples, M);
    for i = 1 : nSamples
%         disp('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
        tmp_ret = runEP(f_star{i}, ymax, sigma2_n, M, max_iter, c);
        ret.m(i, :) = tmp_ret.m;
        ret.v(i, :) = diag(tmp_ret.v);
    end
        
    modelnew = cell(M, nSamples);
    options = model.options;

    for i=1:M
        for j=1:nSamples        
            [Xnew, ynew] = updateXY(model, xstar(j, :), ret.m(j, i), i);
            modelnew{i, j} = multigpCreate_new(model, Xnew, ynew, options);
            [Pinv, Ptinv, ~, sigma2_n, sigma] = getMultigpParames(modelnew{i, j});
            modelnew{i, j}.hypers.Pinv = Pinv;
            modelnew{i, j}.hypers.Ptinv = Ptinv;
            modelnew{i, j}.hypers.sigma = sigma;
            modelnew{i, j}.hypers.sigma2_n = sigma2_n;
        end
    end
    
    
    
    
    
    
    
