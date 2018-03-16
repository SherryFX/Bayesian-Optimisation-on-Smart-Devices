function [ ret ] = getFuncValue_cnn(x, name, t)

    load(name)
    x = transX(x, 'cnn');
    nlf = model.nlf;
    [mu, ~] = multigpPosteriorMeanVar(model, x);
    ret = mu{t+nlf}+model.ymean(t);
    