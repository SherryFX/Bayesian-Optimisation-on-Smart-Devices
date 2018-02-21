function [ret] = entropy_cgp(model, x, type)
    

    [~, var] = multigpPosteriorMeanVar(model, x);
    
    ret = 0.5*log(var{type+model.nlf});
    