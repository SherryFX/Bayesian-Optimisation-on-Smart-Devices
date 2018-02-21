function ret = getFactor_EP(xt, fxstar, params)

    [nSample, M] = size(fxstar);
    astar = zeros(nSample, M);
    for i=1:nSample

        theta = params{i}.theta;
        trans_all = params{i}.trans;
        W_all = params{i}.W;
        b_all = params{i}.b;
        x = xt(i, :)';
        phi = cos(W_all * x + repmat(b_all, 1, size(x, 2)));
        theta = repmat(theta, 1, M) .* trans_all;
        
        astar(i, :) = phi'*theta;

    end
    ret = max(mean(fxstar - astar), 0)';
    
%     nlf = model.nlf;
%     ret = zeros(M, 1);
%     for i=1:M
%         x = reshape(xstar(i, :, :), nSample, d);     
%         [mu, ~] = multigpPosteriorMeanVar(model, [x;xt]);
%         fdiff = reshape(mu{nlf+i}, nSample, 2);
%         ret(i) = max(mean(fdiff(:, 1) - fdiff(:, 2)), 0);
%     end
    