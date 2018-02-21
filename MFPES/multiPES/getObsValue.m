function [ ret ] = getObsValue(task, x, M, type)
    
    task_type = task{M+1};
    switch task_type
        case 'syn'
            seq = task{M+2};
            ret = task{type}(x, seq, true);
        case 'Branin'
            noise = task{M+2};
            ret = task{type}(x, noise(type));
        case 'Hartmann'
            noise = task{M+2};
            ret = task{type}(x, noise(type));
        otherwise
            error('Invalid function type.');
    end