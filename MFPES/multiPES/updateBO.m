function  ret = updateBO(model, X, Y)
    
    if model.train
        
        options = multigpOptions(model.approx);
        options.kernType = 'gg';
        options.optimiser = 'scg';
        options.nlf = model.nlf;
        options.q = model.q;
        options.d = model.M + options.nlf;
        options.M = model.M;
        if isfield(model, 'fixed')
            options.fixed = model.fixed;
        end
        
        ret = CGP_train(X, Y, options, 1000, model.xmin, model.xmax);
        
    else
        options = multigpOptions(model.approx);
        options.kernType = 'gg';
        options.optimiser = 'scg';
        options.nlf = model.nlf;
        options.q = model.q;
        options.d = model.M + options.nlf;
        options.M = model.M;
%         options = model.options; 
        
        ret = multigpCreate_new(model, X, Y, options);
    end
    
end