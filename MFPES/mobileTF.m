load_settings;

% Initialise params
params.numepochs = 1;
params.batchsize = 128;
params.learningrate = 0.001;
params.momentum = 0.2;
params.weightdecay = 0.0002;

[cputime, acc] = target_MobileTF(0,0,params);