function [ys, ctime, rtime, acc] = getObsValue_mobile(x, ftype)

    params.numepochs = x(1);
    params.batchsize = x(2);
    params.learningrate = x(3);
    params.momentum = x(4);
    params.weightdecay = x(5);
    
    if (ftype == 1) 
        [ys, ctime, rtime, acc] = target_MobileTF(params, 0);
        ys = log(ys);
    else
        [ys, ctime, rtime, acc] = auxiliary_MobileTF(params, 0);
        ys = log(ys / 4);
    end
    
    ys = -ys;
end
    
    