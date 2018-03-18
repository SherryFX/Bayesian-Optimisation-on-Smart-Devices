function [ ret ] = getFuncValue_mobile(x, model, t)

%     load(name)
    x = transX(x, 'mobile');
    nlf = model.nlf;
    [mu, ~] = multigpPosteriorMeanVar(model, x);
    ret = mu{t+nlf}+model.ymean(t);
end
    