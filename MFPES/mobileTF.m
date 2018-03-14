clear all, close all

Name = 'MobileTF';
experimentNo = '_multi_PES_h';

load('mobileTF');

noise = [sqrt(0.001), 0.01];    % noise variance for each task

cost = [10, 1];
N = 500;    % maximal no. of observations (NEED TO CHANGE!)
M = 2;  % no. of output types
nlf = 1;    % no. of latent functions
update = 1000;  % when to update the CMOGP hyperparameters
model.train = 0;
T = 10;

opts.discrete = 1;  % (1: multi-start, 0: Direct) for optimization
opts.dis_num = 10;
opts.num = 500;
opts.direct.showits = 0;

task = {@target_MobileTF, @auxiliary_MobileTF, Name, noise};

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

xmin = [20, 0.00001, 50, 0, 0.0001]; % how to ensure values vary discretely for some??
xmax = [100, 0.001, 512, 1, 0.001];

t = 1;
nSample = 50;
nFeatures = 200;

model.M = M;
model.q = size(xmin, 2);
model.nlf = nlf;
model.approx = 'ftc';

d = model.q;
result.X = zeros(T, N, d);
result.y = zeros(T, N);
result.type = zeros(T, N);
result.cost = zeros(T, N);
% result.ymax = zeros(T, N);  % Simple regret
% result.fmax = zeros(T, N);
% result.optimum = zeros(T, N, d);
result.umax_f = zeros(T, N);   % Immediate regret
result.umax_x = zeros(T, N, d);

result.c = zeros(T, N, 2);
result.EPc = zeros(T, N, 2);

givenX = load('start_dim6'); % is this for data? need to change then?
initX = cell(M, 1);

for loop = 1:T
    
    for i=1:M
        initX{i} = givenX.X{i}(loop, :);
    end
    [model, Xobs, Yobs] = initializeBO(model, 'given', task, xmin, xmax, initX);
    
    S = sum(cost);
    
    % result.ymax(loop, S-cost(2):S) = max(Yobs{t});
    % result.fmax(loop, S-cost(2):S) = getFuncValue(task, Xobs{t}, M, t); %task{t}(Xobs{t}, 0, 0);
    [result.umax_f(loop, S-cost(2):S), result.umax_x(loop, 1, :)] = getMaxMean(model, xmin, xmax, task, t, opts);

    result.optimum(loop, 1, :) = Xobs{t};
    
    it = 1;
    while S <= N-cost(t)

        disp(['%%%%%%%%%%%%%%%%%%%%% Step: ', num2str(loop), ', ', num2str(it),  ', cost: ', num2str(S),' %%%%%%%%%%%%%%%%%%%%%']);
        tic
        [xstar, values, params] = sampleXstar(model, nSample, nFeatures, xmin, xmax);
        b = toc;
        disp(['xstar sampling finished. ', num2str(b), ' seconds']);
        % We call the ep method
        target_xstar = reshape(xstar(1, :, :), nSample, d);
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

        y = getObsValue(task, optimum', M, type); %task{type}(optimum', noise(type), S);
        f = getFuncValue(task, optimum', M, type); %task{type}(optimum', 0, S);

        [Xnew, ynew] = updateXY(model, optimum', y, type);

        if(mod(it, update) == 0)
            model.train = 1;
        end
        model = updateBO(model, Xnew, ynew);

        result.X(loop, it, :) = optimum';
        result.y(loop, it) = y;
        result.type(loop, it) = type;
        result.cost(loop, it) = S + cost(type);
        
        % result.ymax(loop, S+1:S+cost(type)) = result.ymax(loop, S);      
        % if type == t && y > result.ymax(loop, S)            
        %         result.ymax(loop, S+cost(type)) = y;
        % end
        
        % result.fmax(loop, S+1:S+cost(type)) = result.fmax(loop, S);      
        % if type == t && f > result.fmax(loop, S)            
        %         result.fmax(loop, S+cost(type)) = f;
        %         result.optimum(loop, it+1, :) = optimum';
        % else
        %     result.optimum(loop, it+1, :) = result.optimum(loop, it, :);
        % end
        
        result.umax_f(loop, S+1:S+cost(type)) = result.umax_f(loop, S);      
        [result.umax_f(loop, S+cost(type)), result.umax_x(loop, it+1, :)] = getMaxMean1(model, xmin, xmax, task, t, opts, result.umax_x(loop, it, :));
        
        S = S + cost(type);
        it = it + 1;
    end 
    % result.ymax(loop, S+1:N) = result.ymax(loop, S);
    % result.fmax(loop, S+1:N) = result.fmax(loop, S);
    result.umax_f(loop, S+1:N) = result.umax_f(loop, S);
    
    save([path, Name, experimentNo, '_result'], 'result', 'model');
end
