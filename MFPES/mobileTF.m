load_settings;

% Initialise params
params.numepochs = 100;
params.batchsize = 256;
params.learningrate = 0.0005;
params.momentum = 0.2;
params.weightdecay = 0.0002;

target_MobileTF(0,0,params);