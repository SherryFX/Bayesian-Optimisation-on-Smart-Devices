function [ys, ctime, rtime, acc] = getObsValue_mobile(x, ftype, pars)

    params.numepochs = x(1);
    params.batchsize = x(2);
    params.learningrate = x(3);
    params.momentum = x(4);
    params.weightdecay = x(5);
    
    if (ftype == 1) 
        [ys, ctime, rtime, acc] = target_MobileTF(params, 0, pars.thresholds{1}, pars.means{1}, pars.stds{1});
    else
        [ys, ctime, rtime, acc] = auxiliary_MobileTF(params, 0, pars.thresholds{2}, pars.means{2}, pars.stds{2});
    end
    
    ys = -ys;
end
