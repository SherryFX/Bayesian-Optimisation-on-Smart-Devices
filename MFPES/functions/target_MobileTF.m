% We evaluate the target function.

function [ ret, ctime, rtime, acc ] = target_MobileTF(params, noise)
    global is_fx id tar_home_dir phone_dir

    disp('Evaluating Target Function');
    
    numepochs = params.numepochs;
    batchsize = params.batchsize;
    learningrate = params.learningrate;
    momentum = params.momentum;
    weightdecay = params.weightdecay;

    res_dir = [tar_home_dir '/MFPES/res'];
    mkdir(res_dir, id);     %res_dir/id/ is the directory storing all the results from the android app for this run

    files=dir([res_dir '/' id '/iter_*_results.csv']);
    iter=-1;
    for f=1:length(files)
        name = files(f).name;
        splitname = strsplit(name, '_');
        iter = max(iter, str2num(splitname{2}));
        
    end
    iter = iter + 1

    if (is_fx)
        cmd_install= [tar_home_dir '/MyApplication/gradlew installDebug'];
    else
        cmd_install= ['cd ' tar_home_dir '/MyApplication & ' tar_home_dir '/MyApplication/gradlew installDebug'];
    end

    [status,cmdout] = system(cmd_install)

    if status == 0
        if (is_fx)
            cmd_adb='/Users/HFX/adb-fastboot/platform-tools/adb';
        else
            cmd_adb='C:\Users\leona\Android\Sdk\platform-tools\adb';
        end

        cmd_run=[cmd_adb ' shell am start -n com.example.myapplication/com.example.myapplication.MainActivity'];
        cmd_run = [cmd_run ' --ei numepochs ' num2str(numepochs)];
        cmd_run = [cmd_run ' --ei batchsize ' num2str(batchsize)];
        cmd_run = [cmd_run ' --ef learningrate ' num2str(learningrate)];
        cmd_run = [cmd_run ' --ef momentum ' num2str(momentum)];
        cmd_run = [cmd_run ' --ef weightdecay ' num2str(weightdecay)];
        cmd_run = [cmd_run ' --ei iter ' num2str(iter)];
        cmd_run = [cmd_run ' --es id ' id];

        [status,cmdout] = system(cmd_run)

        cmd_pull = [cmd_adb ' pull ' ...
            phone_dir '/' id '/iter_' num2str(iter) '_results.csv ' ...
            res_dir '/' id '/iter_' num2str(iter) '_results.csv'];
        cmd_has_crashed = [cmd_adb ' shell pidof com.example.myapplication'];
        % Poll every few seconds until app finishes running 
        while(true) 
            pause(10);
            [pull_status, ~] = system(cmd_pull);
            if (pull_status == 0)
                [num, text, raw] = xlsread([res_dir '/' id '/iter_' num2str(iter) '_results.csv']);
                ctime = num(1) / 10^9;
                rtime = num(2);
                acc = num(3);
                break;
            end
            [crash_status, ~] = system(cmd_has_crashed);
            if (crash_status == 1)
                disp('crashed, trying again');
                system(cmd_run);
            end
        end
    end

    %threshold to be set accordingly later
    threshold = 0.7400;
%     alpha = 10;
     if acc > threshold
        penalty = 1;
    else
%         penalty = exp(alpha*(threshold - acc));
        penalty = acc;
    end
    
%     ret = ctime*penalty;
    ret = ctime/penalty + noise;
end

