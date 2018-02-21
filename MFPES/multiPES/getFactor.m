% Open question: how to define c_i in eq. (5.18)
% My strategy: select the max of f_i(x^i_star) - f_i(x_star)over all sampled functions
% Note: max actually can be replaced by mean/individual/...
function [ret] = getFactor(fi_max, fi_xstar_mu, type, t, method, model, xstar)

    if type == t
        ret = 0;
    else
        switch method
            case 'max'
                ret = max(0, max(fi_max(:, type) - fi_xstar_mu));
            case 'avg'
                ret = max(0,mean(fi_max(:, type) - fi_xstar_mu));
            case 'avg1'
                x = reshape(xstar(type, :, :), size(xstar, 2), size(xstar, 3));
                [mu, ~] = multigpPosteriorMeanVar(model, x);              
                ret = max(0, mean(mu{type+model.nlf} - fi_xstar_mu));
            case 'fixed'
                ret = 0.2;
            case 'max_mean'
                [mu, ~] = multigpPosteriorMeanVar(model, xstar);
                m = mu{type+model.nlf};
                ret = max(0, m(type)-m(t));
            otherwise
                error('Invalid method for computing c.')
        end
    end
    
    
end
