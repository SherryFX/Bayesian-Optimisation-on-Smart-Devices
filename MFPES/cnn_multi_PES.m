clear all, close all

Name = 'CNN';
experimentNo = '_multi';
% path = 'C:\Users\Yehong\Dropbox\Matlab\BO\MTPES\LR_MNIST';
path = '/home/mtlb/yehong/Matlab/BO/results/';
fname = 'cnn_multi.txt';

load('cnn_multi');
model.train = 0;
ymean = [0, 0]; % try setting to average to see if it actually helps with the results
gpu = 0;

cost = [5, 1];
N = 200;
Budget = 72; % training budget: 90 minutes
M = 2;
nlf = 1;
update = 100000;
T = 5; % number of BO to run to get average results to show consistent performance

opts.discrete = 0;
opts.dis_num = 10;
opts.num = 500;
opts.direct.showits = 0;

task = {@target_cnn, @auxiliary_cnn, Name};
 
xmin = [100, 0, 0, 0, log(10.^-5), 100];
xmax = [1000, 1, 1, 1, log(1), 1000];

t = 1;
nSample = 50;
nFeatures = 200;

model.M = M;
model.q = size(xmin, 2);
model.nlf = nlf;
model.approx = 'ftc';
model.xmin = xmin;
model.xmax = xmax;
model.ymean = ymean;

d = model.q;
result.X = zeros(T, N, d);
result.y = zeros(T, N);
result.type = zeros(T, N);
result.ymax = zeros(T, N);
result.fmax = zeros(T, N);
result.umax_f = zeros(T, N);
result.umax_x = zeros(T, N, d);
result.c = zeros(T, N, 2);
result.time_pre = zeros(T, N);
result.time_real = zeros(T, N);

load('start_cnn');
initX = cell(M, 1);
initY = cell(M, 1);
initT = cell(M, 1);

for loop = 1:T
    
    S = 0;
    for i=1:M
        tmp = start_cnn{loop};
        initX{i} = tmp.X{i};
        initY{i} = tmp.y{i};
        S = S + sum(tmp.t{i});
    end
	
    [model, Xobs, Yobs] = initializeBO(model, 'cnn', task, xmin, xmax, initX, initY);   
    model.ymean = ymean;
    
    result.ymax(loop, 1) = max(Yobs{t});
    result.fmax(loop, 1) = max(getFuncValue(task, Xobs{t}, M, t));

    [result.umax_f(loop,1), result.umax_x(loop, 1, :)] = getMaxMean(model, xmin, xmax, task, t, opts);
    result.time_real(loop, 1) = S;

    it = 2;    
    while S <= Budget
        
        disp(['%%%%%%%%%%%%%%%%%%%%% Step: ', num2str(loop), ', ', num2str(it),  ', cost: ', num2str(S),' %%%%%%%%%%%%%%%%%%%%%']);
        tic
        [xstar, values, params] = sampleXstar(model, nSample, nFeatures, xmin, xmax);
        b = toc;
        
        disp(['xstar sampling finished. ', num2str(b), ' seconds']);
        % We call the ep method
        target_xstar = reshape(xstar(1, :, :), nSample, d);

        [fi_xstar, modelnew] = EPapproximation(target_xstar, model, 100); % Eq. (5.16)
        disp('First EP approximation finished.');
        
        acq_func = cell(M, 1);
        entropy_given_xstar = cell(M, 1);
        c = cell(M, 1);
		
        for i=1:M
            c{i} = getFactor(values, fi_xstar.m(:, i), i, t, 'avg', model, xstar);
            result.c(loop, it, i) = c{i};
            entropy_given_xstar{i} = @(x) EPapproximation2_new(x, i, fi_xstar.m(:, i), fi_xstar.v(:, i), modelnew, c{i});    
            acq_func{i} = @(x) (entropy_cgp(model, x', i) - entropy_given_xstar{i}(x'))/cost(i); %getcost_lr(x', i, model_t);
        end

        tic
        [optimum, type] = globalOptimizationNoGradient(acq_func, xmin', xmax', opts);
        b = toc;
        disp(['Next point selected: Elapsed time is ', num2str(b), ' seconds']);
        
        optimum = optimum';
        optimumX = transX(optimum, 'cnn', true);

%         [ys, yt] = getObsValue_cnn(optimumX, type, fname, gpu); %task{type}(optimum', noise(type), S);
        ys = 1;
        yt = 1;
        f = getFuncValue(task, optimumX, M, type); %task{type}(optimum', 0, S);

        [Xnew, ynew] = updateXY(model, optimum, ys-model.ymean(type), type);

        if(mod(it, update) == 0)
            model.train = 1;
        end
        model = updateBO(model, Xnew, ynew);
		model.ymean = ymean;

        result.X(loop, it, :) = optimumX;
        result.y(loop, it) = ys;
        result.type(loop, it) = type;
        result.time_real(loop, it) = result.time_real(loop, it-1) + yt;
        
        result.ymax(loop, it) = max(ys, result.ymax(loop, it-1));
        result.fmax(loop, it) = max(f, result.fmax(loop, it-1));
        
        [result.umax_f(loop, it), result.umax_x(loop, it, :)] = getMaxMean1(model, xmin, xmax, task, t, opts, result.umax_x(loop, it-1, :));

        S = result.time_real(loop, it);
        it = it + 1;
    end 
    
    save([path, Name, experimentNo, '_result'], 'result', 'model');
end


