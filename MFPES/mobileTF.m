clear all, close all

load_settings;

Name = 'MobileTF';
% experimentNo = '_multi_PES_';
experimentNo = '_2_';
path = '/Users/HFX/Desktop/Bayesian Optimization on Smart Devices/MFPES/results/';
fname = 'mobileTF.txt';

load('demMobileTF1');
model.train = 0;
ymean = [0, 0]; % try setting to average to see if it actually helps with the results

% noise = [sqrt(0.001), 0.01];    % noise variance for each task

cost = [5, 1];
N = 200;    % maximal no. of observations
Budget = 50; % training budget: 90 minutes
M = 2;  % no. of output types
nlf = 1;    % no. of latent functions
update = 100000;  % when to update the CMOGP hyperparameters
T = 1;

opts.discrete = 0;  % (1: multi-start, 0: Direct) for optimization
opts.dis_num = 10;
opts.num = 500;
opts.direct.showits = 0;

task = {@target_MobileTF, @auxiliary_MobileTF, Name}; % can add noise if necessary

% load_settings;
% 
% % Initialise params
% params.numepochs = 1;
% params.batchsize = 128;
% params.learningrate = 0.001;
% params.momentum = 0.2;
% params.weightdecay = 0.0002;
% 
% [ctime, rtime, acc] = target_MobileTF(0,0,params);

% num epochs, batchsize, LR, momentum, weight-decay
xmin = [20, 50, log(10.^-5), 0, log(10.^-5)];
xmax = [100, 512, log(10.^-3), 0.99, log(10.^-3)];

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
result.EPc = zeros(T, N, 2); % added!
result.time_pre = zeros(T, N);
result.time_real = zeros(T, N);
% newly added, check?
result.cputime = zeros(T, N);
result.realtime = zeros(T, N);
result.acc = zeros(T, N);

given = load('EMINIST_dataset_mean_thres_norm_ratio'); % create random samples for BO.
ord = randperm(352);
XTemp{1} = given.mainFiltered(ord(1:50), 1:5);
XTemp{2} = given.mainFiltered(ord(1:50), 1:5);
yTemp{1} = -log(given.tarRatio(ord(1:50))); 
yTemp{2} = -log(given.auxRatio(ord(1:50)) / 4);
initX = cell(M, 1);
initY = cell(M, 1);
% initT = cell(M, 1);

for loop = 1:T
    
    S = 0;
    for i=1:M
%         tmp = start_mobileTF{loop};
        initX{i} = transX(XTemp{i}(loop, :), 'mobile', false);
        initY{i} = yTemp{i}(loop);  
%         S = S + sum(tmp.t{i});
    end
	
    [model, Xobs, Yobs] = initializeBO(model, 'mobile', task, xmin, xmax, initX, initY);   
    model.ymean = ymean;
    
    result.ymax(loop, 1) = max(Yobs{t});
    result.fmax(loop, 1) = max(getFuncValue_mobile(Xobs{t}, model, t));

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
        % added!
        EPc = getFactor_EP(target_xstar, values, params); 
        result.EPc(loop, it, :) = EPc;
        
        [fi_xstar, modelnew] = EPapproximation(target_xstar, model, 100, EPc); % Eq. (5.16)

        disp('First EP approximation finished.');
        acq_func = cell(M, 1);
        entropy_given_xstar = cell(M, 1);
        c = cell(M, 1);
		
        for i=1:M
            c{i} = getFactor(values, fi_xstar.m(:, i), i, t, 'avg', model, xstar);
            result.c(loop, it, i) = c{i};
            entropy_given_xstar{i} = @(x) EPapproximation2(x, i, fi_xstar.m(:, i), fi_xstar.v(:, i), modelnew, c{i});    
            acq_func{i} = @(x) (entropy_cgp(model, x', i) - entropy_given_xstar{i}(x'))/cost(i);
        end
        
        tic
        [optimum, type] = globalOptimizationNoGradient(acq_func, xmin', xmax', opts);
        b = toc;
        disp(['Next point selected: Elapsed time is ', num2str(b), ' seconds']);

        optimum = optimum';
        optimumX = transX(optimum, 'mobile', true);
        disp(['Selected point: ', num2str(optimumX(1)), ', ', num2str(optimumX(2)), ', ', num2str(optimumX(3)), ', ', num2str(optimumX(4)), ', ', num2str(optimumX(5))]);
        disp(['Selected funciton: ', num2str(type)]);
        
        [ys, ctime, rtime, acc] = getObsValue_mobile(optimumX, type); %task{type}(optimum', noise(type), S);
%         ys = 1;
%         yt = 1;
        f = getFuncValue_mobile(optimumX, model, type); %task{type}(optimum', 0, S);
        disp(['Function Value: ', num2str(f)]);

        [Xnew, ynew] = updateXY(model, optimum, ys-model.ymean(type), type);

        if(mod(it, update) == 0)
            model.train = 1;
        end
        model = updateBO(model, Xnew, ynew);
		model.ymean = ymean;

        result.X(loop, it, :) = optimumX;
        result.y(loop, it) = ys;
        result.type(loop, it) = type;
        result.cputime(loop, it) = ctime;
        result.realtime(loop, it) = rtime;
        result.acc(loop, it) = acc;
        result.time_real(loop, it) = result.time_real(loop, it-1) + yt; % change to suit context
        
        result.ymax(loop, it) = max(ys, result.ymax(loop, it-1));
        result.fmax(loop, it) = max(f, result.fmax(loop, it-1));
        
        [result.umax_f(loop, it), result.umax_x(loop, it, :)] = getMaxMean1(model, xmin, xmax, task, t, opts, result.umax_x(loop, it-1, :));

        S = result.time_real(loop, it);
        it = it + 1;
    end 
    result.ymax(loop, S+1:N) = result.ymax(loop, S);
    % result.fmax(loop, S+1:N) = result.fmax(loop, S);
    result.umax_f(loop, S+1:N) = result.umax_f(loop, S);
    
%     save([path, Name, experimentNo, '_result'], 'result', 'model');       
    save([path, Name, experimentNo, '_result'], 'result', 'model');

end
