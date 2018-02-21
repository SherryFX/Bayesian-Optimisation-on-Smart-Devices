function [ ret ] = getFuncValue(task, x, M, type)
    
    task_type = task{M+1};
    switch task_type
        case 'syn'
            seq = task{M+2};
            ret = task{type}(x, seq);
        case 'Branin'
            ret = task{type}(x, 0);
        case 'Hartmann'
            ret = task{type}(x, 0);
        case 'LR'
%             x = transX(x, 'lr', true);
            ret = getFuncValue_lr(x, 'lr_model', type);
        case 'CNN'
%             x = transX(x, 'lr', true);
            ret = getFuncValue_cnn(x, 'cnn_multi', type);
        otherwise
            error('Invalid function type.');
    end