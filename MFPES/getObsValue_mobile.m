function [ys, yt] = getObsValue_mobile(x, type, fname, gpu)

    % change!!
    cd ~/yehong/CNN_CIFAR10

    method = {'full', 'small'};
    
    % construct the command
    pcmd = ['CUDA_VISIBLE_DEVICES=', num2str(gpu), ...
        ' python logistic_regression_mnist.py --d1 ', num2str(x(2)), ...
        ' --d2 ', num2str(x(3)), ' --d3 ', num2str(x(4)), ...
        ' --lr ', num2str(x(5)), ' --epochs ', num2str(x(1)), ...
        ' --batch_size ', num2str(x(6))];
    
    pcmd = [pcmd, ' --method ', method{type}];
    
    % run python code
    system(pcmd);
    
    res = load(fname);  % save the python results in a file and load it.
    ys = res(1);
    yt = res(2);
end
    
    