function [xnew] = transX(x, method, inverse)
    
    if nargin < 3
        inverse = false;
    end
    
    if inverse
        switch method
            case 'lr'              
                xnew(:, 1:2) = exp(x(:, 1:2));
                xnew(:, 3:4) = round(x(:, 3:4));
            case 'cnn'
                xnew(:, [1,6]) = round(x(:, [1,6]));
                xnew(:, 5) = exp(x(:, 5));
            case 'mobile'
                % transform values back to real values
                xnew(:, [1,2]) = round(x(:, [1,2]));
                xnew(:, 3) = exp(-x(:, 3));
                xnew(:, 4) = x(:,4);
                xnew(:, 5) = exp(-x(:, 5));
            otherwise
                xnew = x;
        end
    else
        switch method
            case 'lr'              
                xnew(:, 1:2) = log(x(:, 1:2));
                xnew(:, 3:4) = x(:, 3:4);
            case 'cnn'
                xnew = x;
                xnew(:, 5) = log(x(:, 5));
            case 'mobile'
                % transform values to GP appropriate values
                xnew = x;
                xnew(:, 3) = -log(x(:, 3));
                xnew(:, 4) = x(:,4);
                xnew(:, 5) = -log(x(:, 5));
            otherwise
                xnew = x;
        end
    end