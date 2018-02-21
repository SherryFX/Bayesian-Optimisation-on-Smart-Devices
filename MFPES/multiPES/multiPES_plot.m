function [fig1, fig2] = multiPES_plot(xsa, model, task, func2, params, xstar, xmin, xmax, num, optimum, type, cost, umax)
    
    imgTitle = {'Task1', '$\mu_{Y_1|D_n}$', 'MTRF-$f_1(x)$';
        'Task2', '$\mu_{Y_2|D_n}$', 'MTRF-$f_2(x)$'};
    
    M = model.M;
    nlf = model.nlf;
    d = model.q;
    task_type = task{M+1};

    a = linspace(xmin(1), xmax(1), num);
    b = linspace(xmin(2), xmax(2), num);
    [a1, b1] = meshgrid(a, b);
    n = 3;

    Xtest = [reshape(a1, num*num, 1), reshape(b1, num*num, 1)];
    [mu, varsigma] = multigpPosteriorMeanVar(model, Xtest);

    figure
    set(gcf,'DefaultTextInterpreter','latex')
    %%% Plot the ground truth of the tasks
    for i=1:M
        func_name = task{i};
        switch task_type
            case 'syn'
                true = reshape(func_name(Xtest, task{M+2}), num, num);
            case 'Branin'
                true = reshape(func_name(Xtest, 0, 1), num, num);
            otherwise
                error('Invalid function.')
        end
%         true = reshape(func_name(Xtest, 0, 1), num, num);
        subplot(M,n,1+(i-1)*n)
        imagesc([xmin(1), xmax(1)], [xmin(2), xmax(2)], true); axis xy; axis equal; axis tight;
        title(imgTitle{i, 1});
        colorbar
        hold on
        X = model.X{i+nlf};
        plot(X(:, 1), X(:, 2), 'w*')
        
        %%%% Plot the predictive mean and entropy
        mu_t = reshape(mu{i+nlf}, num, num);
        subplot(M,n,2+(i-1)*n)
        imagesc([xmin(1), xmax(1)], [xmin(2), xmax(2)], mu_t); axis xy; axis equal; axis tight;
        if i == 1
            hold on
            plot(umax(1), umax(2), 'wo', 'MarkerFaceColor','w');
        end
        title(imgTitle{i, 2});
        colorbar
    end

    for j = 1:M
        func_value = zeros(num*num, 1);
        for i = 1:size(params, 1)
            targetVector = @(X) (params{i}.theta' * diag(params{i}.trans(:, j)) ...
                * cos(params{i}.W * X' + repmat(params{i}.b, 1, size(X, 1))))';
            func_value = func_value + targetVector(Xtest);
        end
        func_value = reshape(func_value./size(params, 1), num, num);
        
        subplot(M,n,3+(j-1)*n)
        imagesc([xmin(1), xmax(1)], [xmin(2), xmax(2)], func_value); axis xy; axis equal; axis tight;
        title(imgTitle{j, 3});
        colorbar
        
        hold on
        xs = reshape(xstar(j, :, :), size(params, 1), d);
        plot(xs(:, 1), xs(:, 2), 'w+')
    end
    
    fig1 = gcf;
%     fig1 = 0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imgTitle2 = {'$H(Y_1|D_n)$', '$H(Y_1|D_n, x_*)$', 'acq1';
    '$H(Y_2|D_n)$', '$H(Y_2|D_n, x_*)$', 'acq2'};
    
    figure
    for i=1:M
        %%% plot H(Y|D_n)
        entropy_t = reshape(0.5*log(varsigma{i+nlf}), num, num);
        entropy_t(~isreal(entropy_t)) = nan;
        entropy_t = real(entropy_t);

        subplot(M,n,1+(i-1)*n)
        imagesc([xmin(1), xmax(1)], [xmin(2), xmax(2)], entropy_t); axis xy; axis equal; axis tight;
        title(imgTitle2{i, 1});
        colorbar
        
        %%% plot H(Y|D_n, x*)
        entropy_new = zeros(num*num, 1);
        for j = 1:size(Xtest, 1)
            if mod(j,100) == 0
                disp([num2str(i), ', ', num2str(j)]);
            end            
            entropy_new(j) = func2{i}(Xtest(j, :));
        end
        
        entropy_new = reshape(entropy_new, num, num);
        entropy_new(~isreal(entropy_new)) = entropy_t(~isreal(entropy_new));      
        entropy_new = real(entropy_new);
        
%         save entropy_new entropy_new;
        subplot(M,n,2+(i-1)*n)
        imagesc([xmin(1), xmax(1)], [xmin(2), xmax(2)], entropy_new); axis xy; axis equal; axis tight;
        title(imgTitle2{i, 2});
        colorbar
        
        acq = (entropy_t - entropy_new)./cost(i);
        
        subplot(M,n,3+(i-1)*n)
        imagesc([xmin(1), xmax(1)], [xmin(2), xmax(2)], acq); axis xy; axis equal; axis tight;
        title(imgTitle2{i, 3});
        colorbar
        
        if type == i
            hold on
            plot(optimum(1), optimum(2), 'wo', 'MarkerFaceColor','w');
            hold on
            plot(xsa(1), xsa(2), 'w^', 'MarkerFaceColor','w');
        end
    end
    
    fig2 = gcf;

